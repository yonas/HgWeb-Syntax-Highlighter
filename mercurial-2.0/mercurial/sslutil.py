# sslutil.py - SSL handling for mercurial
#
# Copyright 2005, 2006, 2007, 2008 Matt Mackall <mpm@selenic.com>
# Copyright 2006, 2007 Alexis S. L. Carvalho <alexis@cecm.usp.br>
# Copyright 2006 Vadim Gelfer <vadim.gelfer@gmail.com>
#
# This software may be used and distributed according to the terms of the
# GNU General Public License version 2 or any later version.
import os

from mercurial import util
from mercurial.i18n import _
try:
    # avoid using deprecated/broken FakeSocket in python 2.6
    import ssl
    ssl_wrap_socket = ssl.wrap_socket
    CERT_REQUIRED = ssl.CERT_REQUIRED
except ImportError:
    CERT_REQUIRED = 2

    import socket, httplib

    def ssl_wrap_socket(sock, key_file, cert_file,
                        cert_reqs=CERT_REQUIRED, ca_certs=None):
        if not util.safehasattr(socket, 'ssl'):
            raise util.Abort(_('Python SSL support not found'))
        if ca_certs:
            raise util.Abort(_(
                'certificate checking requires Python 2.6'))

        ssl = socket.ssl(sock, key_file, cert_file)
        return httplib.FakeSocket(sock, ssl)

def _verifycert(cert, hostname):
    '''Verify that cert (in socket.getpeercert() format) matches hostname.
    CRLs is not handled.

    Returns error message if any problems are found and None on success.
    '''
    if not cert:
        return _('no certificate received')
    dnsname = hostname.lower()
    def matchdnsname(certname):
        return (certname == dnsname or
                '.' in dnsname and certname == '*.' + dnsname.split('.', 1)[1])

    san = cert.get('subjectAltName', [])
    if san:
        certnames = [value.lower() for key, value in san if key == 'DNS']
        for name in certnames:
            if matchdnsname(name):
                return None
        if certnames:
            return _('certificate is for %s') % ', '.join(certnames)

    # subject is only checked when subjectAltName is empty
    for s in cert.get('subject', []):
        key, value = s[0]
        if key == 'commonName':
            try:
                # 'subject' entries are unicode
                certname = value.lower().encode('ascii')
            except UnicodeEncodeError:
                return _('IDN in certificate not supported')
            if matchdnsname(certname):
                return None
            return _('certificate is for %s') % certname
    return _('no commonName or subjectAltName found in certificate')


# CERT_REQUIRED means fetch the cert from the server all the time AND
# validate it against the CA store provided in web.cacerts.
#
# We COMPLETELY ignore CERT_REQUIRED on Python <= 2.5, as it's totally
# busted on those versions.

def sslkwargs(ui, host):
    cacerts = ui.config('web', 'cacerts')
    hostfingerprint = ui.config('hostfingerprints', host)
    if cacerts and not hostfingerprint:
        cacerts = util.expandpath(cacerts)
        if not os.path.exists(cacerts):
            raise util.Abort(_('could not find web.cacerts: %s') % cacerts)
        return {'ca_certs': cacerts,
                'cert_reqs': CERT_REQUIRED,
                }
    return {}

class validator(object):
    def __init__(self, ui, host):
        self.ui = ui
        self.host = host

    def __call__(self, sock):
        host = self.host
        cacerts = self.ui.config('web', 'cacerts')
        hostfingerprint = self.ui.config('hostfingerprints', host)
        if cacerts and not hostfingerprint:
            msg = _verifycert(sock.getpeercert(), host)
            if msg:
                raise util.Abort(_('%s certificate error: %s '
                                   '(use --insecure to connect '
                                   'insecurely)') % (host, msg))
            self.ui.debug('%s certificate successfully verified\n' % host)
        else:
            if getattr(sock, 'getpeercert', False):
                peercert = sock.getpeercert(True)
                peerfingerprint = util.sha1(peercert).hexdigest()
                nicefingerprint = ":".join([peerfingerprint[x:x + 2]
                    for x in xrange(0, len(peerfingerprint), 2)])
                if hostfingerprint:
                    if peerfingerprint.lower() != \
                            hostfingerprint.replace(':', '').lower():
                        raise util.Abort(_('invalid certificate for %s '
                                           'with fingerprint %s') %
                                         (host, nicefingerprint))
                    self.ui.debug('%s certificate matched fingerprint %s\n' %
                                  (host, nicefingerprint))
                else:
                    self.ui.warn(_('warning: %s certificate '
                                   'with fingerprint %s not verified '
                                   '(check hostfingerprints or web.cacerts '
                                   'config setting)\n') %
                                 (host, nicefingerprint))
            else: # python 2.5 ?
                if hostfingerprint:
                    raise util.Abort(_("host fingerprint for %s can't be "
                                       "verified (Python too old)") % host)
                self.ui.warn(_("warning: certificate for %s can't be "
                               "verified (Python too old)\n") % host)
