
  $ hgserve()
  > {
  >    hg serve -a localhost -d --pid-file=hg.pid -E errors.log -v $@ \
  >        | sed -e "s/:$HGPORT1\\([^0-9]\\)/:HGPORT1\1/g" \
  >              -e "s/:$HGPORT2\\([^0-9]\\)/:HGPORT2\1/g" \
  >              -e 's/http:\/\/[^/]*\//http:\/\/localhost\//'
  >    cat hg.pid >> "$DAEMON_PIDS"
  >    echo % errors
  >    cat errors.log
  >    sleep 1
  >    if [ "$KILLQUIETLY" = "Y" ]; then
  >        kill `cat hg.pid` 2>/dev/null
  >    else
  >        kill `cat hg.pid`
  >    fi
  >    sleep 1
  > }

  $ hg init test
  $ cd test
  $ echo '[web]' > .hg/hgrc
  $ echo 'accesslog = access.log' >> .hg/hgrc
  $ echo "port = $HGPORT1" >> .hg/hgrc

Without -v

  $ hg serve -a localhost -p $HGPORT -d --pid-file=hg.pid -E errors.log
  $ cat hg.pid >> "$DAEMON_PIDS"
  $ if [ -f access.log ]; then
  $     echo 'access log created - .hg/hgrc respected'
  access log created - .hg/hgrc respected
  $ fi

errors

  $ cat errors.log

With -v

  $ hgserve
  listening at http://localhost/ (bound to 127.0.0.1:HGPORT1)
  % errors

With -v and -p HGPORT2

  $ hgserve -p "$HGPORT2"
  listening at http://localhost/ (bound to 127.0.0.1:HGPORT2)
  % errors

With -v and -p daytime (should fail because low port)

  $ KILLQUIETLY=Y
  $ hgserve -p daytime
  abort: cannot start server at 'localhost:13': Permission denied
  abort: child process failed to start
  % errors
  $ KILLQUIETLY=N

With --prefix foo

  $ hgserve --prefix foo
  listening at http://localhost/foo/ (bound to 127.0.0.1:HGPORT1)
  % errors

With --prefix /foo

  $ hgserve --prefix /foo
  listening at http://localhost/foo/ (bound to 127.0.0.1:HGPORT1)
  % errors

With --prefix foo/

  $ hgserve --prefix foo/
  listening at http://localhost/foo/ (bound to 127.0.0.1:HGPORT1)
  % errors

With --prefix /foo/

  $ hgserve --prefix /foo/
  listening at http://localhost/foo/ (bound to 127.0.0.1:HGPORT1)
  % errors
