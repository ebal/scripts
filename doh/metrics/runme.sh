#!/bin/sh

awk '{print "/usr/bin/time -o top100 -a -f %E curl -s  https://doh.libredns.gr/dns-query?name="$1" > /tmp/foobar"}' list | sh

for i in `seq 1000`; do /usr/bin/time -o 1000.times -a -f %E curl -s  https://doh.libredns.gr/dns-query?name=libredns.gr > /tmp/foobar; done
