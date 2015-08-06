#!/bin/env python

# pdns.conf #
# launch=bind, remote
# remote-connection-string=pipe:command=/path/to/pdns_remote_api_pipe.py,timeout=60

import syslog
import sys
import json

syslog.syslog ( sys.argv[0] )

# sys.stdin, sys.stdout

reader = sys.stdin
writer = sys.stdout

while(True):
    line = reader.readline()

    # tail syslog for debug
    syslog.syslog( line )

    if line == "":
        break
    try:
        # initialize
        writer.write(json.dumps({'result':True}))
    except ValueError:
        writer.write(json.dumps({'result':False,'log':"Cannot parse input"}))
    writer.write("\n")
    writer.flush()

# vim: tabstop=4 expandtab shiftwidth=4 softtabstop=4
