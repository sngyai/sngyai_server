#!/bin/sh
# NOTE: mustache templates need \ because they are not awesome.
exec erl -sname sngyai@127.0.0.1 -setcookie 123   -sname  main server_start
#erl -setcookie abc -name sngyai@192.168.1.123 main server_start
