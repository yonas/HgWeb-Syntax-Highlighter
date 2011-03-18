# record.py
#
# Copyright 2007 Bryan O'Sullivan <bos@serpentine.com>
#
# This software may be used and distributed according to the terms of the
# GNU General Public License version 2 or any later version.

'''commands to interactively select changes for commit/qrefresh'''

from mercurial.i18n import gettext, _
from mercurial import cmdutil, commands, extensions, hg, mdiff, patch
from mercurial import util
import copy, cStringIO, errno, os, re, shutil, tempfile

lines_re = re.compile(r'@@ -(\d+),(\d+) \+(\d+),(\d+) @@\s*(.*)')

def scanpatch(fp):
    """like patch.iterhunks, but yield different events

    - ('file',    [header_lines + fromfile + tofile])
    - ('context', [context_lines])
    - ('hunk',    [hunk_lines])
    - ('range',   (-start,len, +start,len, diffp))
    """
    lr = patch.linereader(fp)

    def scanwhile(first, p):
        """scan lr while predicate holds"""
        lines = [first]
        while True:
            line = lr.readline()
            if not line:
                break
            if p(line):
                lines.append(line)
            else:
                lr.push(line)
                break
        return lines

    while True:
        line = lr.readline()
        if not line:
            break
        if line.startswith('diff --git a/') or line.startswith('diff -r '):
            def notheader(line):
                s = line.split(None, 1)
                return not s or s[0] not in ('---', 'diff')
            header = scanwhile(line, notheader)
            fromfile = lr.readline()
            if fromfile.startswith('---'):
                tofile = lr.readline()
                header += [fromfile, tofile]
            else:
                lr.push(fromfile)
            yield 'file', header
        elif line[0] == ' ':
            yield 'context', scanwhile(line, lambda l: l[0] in ' \\')
        elif line[0] in '-+':
            yield 'hunk', scanwhile(line, lambda l: l[0] in '-+\\')
        else:
            m = lines_re.match(line)
            if m:
                yield 'range', m.groups()
            else:
                raise patch.PatchError('unknown patch content: %r' % line)

class header(object):
    """patch header

    XXX shoudn't we move this to mercurial/patch.py ?
    """
    diffgit_re = re.compile('diff --git a/(.*) b/(.*)$')
    diff_re = re.compile('diff -r .* (.*)$')
    allhunks_re = re.compile('(?:index|new file|deleted file) ')
    pretty_re = re.compile('(?:new file|deleted file) ')
    special_re = re.compile('(?:index|new|deleted|copy|rename) ')

    def __init__(self, header):
        self.header = header
        self.hunks = []

    def binary(self):
        return util.any(h.startswith('index ') for h in self.header)

    def pretty(self, fp):
        for h in self.header:
            if h.startswith('index '):
                fp.write(_('this modifies a binary file (all or nothing)\n'))
                break
            if self.pretty_re.match(h):
                fp.write(h)
                if self.binary():
                    fp.write(_('this is a binary file\n'))
                break
            if h.startswith('---'):
                fp.write(_('%d hunks, %d lines changed\n') %
                         (len(self.hunks),
                          sum([max(h.added, h.removed) for h in self.hunks])))
                break
            fp.write(h)

    def write(self, fp):
        fp.write(''.join(self.header))

    def allhunks(self):
        return util.any(self.allhunks_re.match(h) for h in self.header)

    def files(self):
        match = self.diffgit_re.match(self.header[0])
        if match:
            fromfile, tofile = match.groups()
            if fromfile == tofile:
                return [fromfile]
            return [fromfile, tofile]
        else:
            return self.diff_re.match(self.header[0]).groups()

    def filename(self):
        return self.files()[-1]

    def __repr__(self):
        return '<header %s>' % (' '.join(map(repr, self.files())))

    def special(self):
        return util.any(self.special_re.match(h) for h in self.header)

def countchanges(hunk):
    """hunk -> (n+,n-)"""
    add = len([h for h in hunk if h[0] == '+'])
    rem = len([h for h in hunk if h[0] == '-'])
    return add, rem

class hunk(object):
    """patch hunk

    XXX shouldn't we merge this with patch.hunk ?
    """
    maxcontext = 3

    def __init__(self, header, fromline, toline, proc, before, hunk, after):
        def trimcontext(number, lines):
            delta = len(lines) - self.maxcontext
            if False and delta > 0:
                return number + delta, lines[:self.maxcontext]
            return number, lines

        self.header = header
        self.fromline, self.before = trimcontext(fromline, before)
        self.toline, self.after = trimcontext(toline, after)
        self.proc = proc
        self.hunk = hunk
        self.added, self.removed = countchanges(self.hunk)

    def write(self, fp):
        delta = len(self.before) + len(self.after)
        if self.after and self.after[-1] == '\\ No newline at end of file\n':
            delta -= 1
        fromlen = delta + self.removed
        tolen = delta + self.added
        fp.write('@@ -%d,%d +%d,%d @@%s\n' %
                 (self.fromline, fromlen, self.toline, tolen,
                  self.proc and (' ' + self.proc)))
        fp.write(''.join(self.before + self.hunk + self.after))

    pretty = write

    def filename(self):
        return self.header.filename()

    def __repr__(self):
        return '<hunk %r@%d>' % (self.filename(), self.fromline)

def parsepatch(fp):
    """patch -> [] of headers -> [] of hunks """
    class parser(object):
        """patch parsing state machine"""
        def __init__(self):
            self.fromline = 0
            self.toline = 0
            self.proc = ''
            self.header = None
            self.context = []
            self.before = []
            self.hunk = []
            self.headers = []

        def addrange(self, limits):
            fromstart, fromend, tostart, toend, proc = limits
            self.fromline = int(fromstart)
            self.toline = int(tostart)
            self.proc = proc

        def addcontext(self, context):
            if self.hunk:
                h = hunk(self.header, self.fromline, self.toline, self.proc,
                         self.before, self.hunk, context)
                self.header.hunks.append(h)
                self.fromline += len(self.before) + h.removed
                self.toline += len(self.before) + h.added
                self.before = []
                self.hunk = []
                self.proc = ''
            self.context = context

        def addhunk(self, hunk):
            if self.context:
                self.before = self.context
                self.context = []
            self.hunk = hunk

        def newfile(self, hdr):
            self.addcontext([])
            h = header(hdr)
            self.headers.append(h)
            self.header = h

        def finished(self):
            self.addcontext([])
            return self.headers

        transitions = {
            'file': {'context': addcontext,
                     'file': newfile,
                     'hunk': addhunk,
                     'range': addrange},
            'context': {'file': newfile,
                        'hunk': addhunk,
                        'range': addrange},
            'hunk': {'context': addcontext,
                     'file': newfile,
                     'range': addrange},
            'range': {'context': addcontext,
                      'hunk': addhunk},
            }

    p = parser()

    state = 'context'
    for newstate, data in scanpatch(fp):
        try:
            p.transitions[state][newstate](p, data)
        except KeyError:
            raise patch.PatchError('unhandled transition: %s -> %s' %
                                   (state, newstate))
        state = newstate
    return p.finished()

def filterpatch(ui, headers):
    """Interactively filter patch chunks into applied-only chunks"""

    def prompt(skipfile, skipall, query):
        """prompt query, and process base inputs

        - y/n for the rest of file
        - y/n for the rest
        - ? (help)
        - q (quit)

        Return True/False and possibly updated skipfile and skipall.
        """
        if skipall is not None:
            return skipall, skipfile, skipall
        if skipfile is not None:
            return skipfile, skipfile, skipall
        while True:
            resps = _('[Ynsfdaq?]')
            choices = (_('&Yes, record this change'),
                    _('&No, skip this change'),
                    _('&Skip remaining changes to this file'),
                    _('Record remaining changes to this &file'),
                    _('&Done, skip remaining changes and files'),
                    _('Record &all changes to all remaining files'),
                    _('&Quit, recording no changes'),
                    _('&?'))
            r = ui.promptchoice("%s %s" % (query, resps), choices)
            ui.write("\n")
            if r == 7: # ?
                doc = gettext(record.__doc__)
                c = doc.find('::') + 2
                for l in doc[c:].splitlines():
                    if l.startswith('      '):
                        ui.write(l.strip(), '\n')
                continue
            elif r == 0: # yes
                ret = True
            elif r == 1: # no
                ret = False
            elif r == 2: # Skip
                ret = skipfile = False
            elif r == 3: # file (Record remaining)
                ret = skipfile = True
            elif r == 4: # done, skip remaining
                ret = skipall = False
            elif r == 5: # all
                ret = skipall = True
            elif r == 6: # quit
                raise util.Abort(_('user quit'))
            return ret, skipfile, skipall

    seen = set()
    applied = {}        # 'filename' -> [] of chunks
    skipfile, skipall = None, None
    pos, total = 1, sum(len(h.hunks) for h in headers)
    for h in headers:
        pos += len(h.hunks)
        skipfile = None
        fixoffset = 0
        hdr = ''.join(h.header)
        if hdr in seen:
            continue
        seen.add(hdr)
        if skipall is None:
            h.pretty(ui)
        msg = (_('examine changes to %s?') %
               _(' and ').join(map(repr, h.files())))
        r, skipfile, skipall = prompt(skipfile, skipall, msg)
        if not r:
            continue
        applied[h.filename()] = [h]
        if h.allhunks():
            applied[h.filename()] += h.hunks
            continue
        for i, chunk in enumerate(h.hunks):
            if skipfile is None and skipall is None:
                chunk.pretty(ui)
            msg = (total == 1
                   and (_('record this change to %r?') % chunk.filename())
                   or (_('record change %d/%d to %r?') %
                       (pos - len(h.hunks) + i, total, chunk.filename())))
            r, skipfile, skipall = prompt(skipfile, skipall, msg)
            if r:
                if fixoffset:
                    chunk = copy.copy(chunk)
                    chunk.toline += fixoffset
                applied[chunk.filename()].append(chunk)
            else:
                fixoffset += chunk.removed - chunk.added
    return sum([h for h in applied.itervalues()
               if h[0].special() or len(h) > 1], [])

def record(ui, repo, *pats, **opts):
    '''interactively select changes to commit

    If a list of files is omitted, all changes reported by :hg:`status`
    will be candidates for recording.

    See :hg:`help dates` for a list of formats valid for -d/--date.

    You will be prompted for whether to record changes to each
    modified file, and for files with multiple changes, for each
    change to use. For each query, the following responses are
    possible::

      y - record this change
      n - skip this change

      s - skip remaining changes to this file
      f - record remaining changes to this file

      d - done, skip remaining changes and files
      a - record all changes to all remaining files
      q - quit, recording no changes

      ? - display help

    This command is not available when committing a merge.'''

    dorecord(ui, repo, commands.commit, *pats, **opts)


def qrecord(ui, repo, patch, *pats, **opts):
    '''interactively record a new patch

    See :hg:`help qnew` & :hg:`help record` for more information and
    usage.
    '''

    try:
        mq = extensions.find('mq')
    except KeyError:
        raise util.Abort(_("'mq' extension not loaded"))

    def committomq(ui, repo, *pats, **opts):
        mq.new(ui, repo, patch, *pats, **opts)

    dorecord(ui, repo, committomq, *pats, **opts)


def dorecord(ui, repo, commitfunc, *pats, **opts):
    if not ui.interactive():
        raise util.Abort(_('running non-interactively, use commit instead'))

    def recordfunc(ui, repo, message, match, opts):
        """This is generic record driver.

        Its job is to interactively filter local changes, and
        accordingly prepare working directory into a state in which the
        job can be delegated to a non-interactive commit command such as
        'commit' or 'qrefresh'.

        After the actual job is done by non-interactive command, the
        working directory is restored to its original state.

        In the end we'll record interesting changes, and everything else
        will be left in place, so the user can continue working.
        """

        merge = len(repo[None].parents()) > 1
        if merge:
            raise util.Abort(_('cannot partially commit a merge '
                               '(use "hg commit" instead)'))

        changes = repo.status(match=match)[:3]
        diffopts = mdiff.diffopts(git=True, nodates=True)
        chunks = patch.diff(repo, changes=changes, opts=diffopts)
        fp = cStringIO.StringIO()
        fp.write(''.join(chunks))
        fp.seek(0)

        # 1. filter patch, so we have intending-to apply subset of it
        chunks = filterpatch(ui, parsepatch(fp))
        del fp

        contenders = set()
        for h in chunks:
            try:
                contenders.update(set(h.files()))
            except AttributeError:
                pass

        changed = changes[0] + changes[1] + changes[2]
        newfiles = [f for f in changed if f in contenders]
        if not newfiles:
            ui.status(_('no changes to record\n'))
            return 0

        modified = set(changes[0])

        # 2. backup changed files, so we can restore them in the end
        backups = {}
        backupdir = repo.join('record-backups')
        try:
            os.mkdir(backupdir)
        except OSError, err:
            if err.errno != errno.EEXIST:
                raise
        try:
            # backup continues
            for f in newfiles:
                if f not in modified:
                    continue
                fd, tmpname = tempfile.mkstemp(prefix=f.replace('/', '_')+'.',
                                               dir=backupdir)
                os.close(fd)
                ui.debug('backup %r as %r\n' % (f, tmpname))
                util.copyfile(repo.wjoin(f), tmpname)
                shutil.copystat(repo.wjoin(f), tmpname)
                backups[f] = tmpname

            fp = cStringIO.StringIO()
            for c in chunks:
                if c.filename() in backups:
                    c.write(fp)
            dopatch = fp.tell()
            fp.seek(0)

            # 3a. apply filtered patch to clean repo  (clean)
            if backups:
                hg.revert(repo, repo.dirstate.parents()[0],
                          lambda key: key in backups)

            # 3b. (apply)
            if dopatch:
                try:
                    ui.debug('applying patch\n')
                    ui.debug(fp.getvalue())
                    pfiles = {}
                    patch.internalpatch(fp, ui, 1, repo.root, files=pfiles,
                                        eolmode=None)
                    cmdutil.updatedir(ui, repo, pfiles)
                except patch.PatchError, err:
                    raise util.Abort(str(err))
            del fp

            # 4. We prepared working directory according to filtered
            #    patch. Now is the time to delegate the job to
            #    commit/qrefresh or the like!

            # it is important to first chdir to repo root -- we'll call
            # a highlevel command with list of pathnames relative to
            # repo root
            cwd = os.getcwd()
            os.chdir(repo.root)
            try:
                commitfunc(ui, repo, *newfiles, **opts)
            finally:
                os.chdir(cwd)

            return 0
        finally:
            # 5. finally restore backed-up files
            try:
                for realname, tmpname in backups.iteritems():
                    ui.debug('restoring %r to %r\n' % (tmpname, realname))
                    util.copyfile(tmpname, repo.wjoin(realname))
                    # Our calls to copystat() here and above are a
                    # hack to trick any editors that have f open that
                    # we haven't modified them.
                    #
                    # Also note that this racy as an editor could
                    # notice the file's mtime before we've finished
                    # writing it.
                    shutil.copystat(tmpname, repo.wjoin(realname))
                    os.unlink(tmpname)
                os.rmdir(backupdir)
            except OSError:
                pass

    # wrap ui.write so diff output can be labeled/colorized
    def wrapwrite(orig, *args, **kw):
        label = kw.pop('label', '')
        for chunk, l in patch.difflabel(lambda: args):
            orig(chunk, label=label + l)
    oldwrite = ui.write
    extensions.wrapfunction(ui, 'write', wrapwrite)
    try:
        return cmdutil.commit(ui, repo, recordfunc, pats, opts)
    finally:
        ui.write = oldwrite

cmdtable = {
    "record":
        (record, commands.table['^commit|ci'][1], # same options as commit
         _('hg record [OPTION]... [FILE]...')),
}


def uisetup(ui):
    try:
        mq = extensions.find('mq')
    except KeyError:
        return

    qcmdtable = {
    "qrecord":
        (qrecord, mq.cmdtable['^qnew'][1], # same options as qnew
         _('hg qrecord [OPTION]... PATCH [FILE]...')),
    }

    cmdtable.update(qcmdtable)

