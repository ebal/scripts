#!/bin/sh

# ebal, Sat, 26 Oct 2019 00:42:26 +0300
timestamp=`date +%s`

for i in $(cat list); do
    /usr/bin/time -o top100.$timestamp -a -f %E curl -s https://doh.libredns.gr/dns-query?name=$i > /dev/null;
done

for i in `seq 1000`; do
    /usr/bin/time -o 1000.times.$timestamp -a -f %E curl -s  https://doh.libredns.gr/dns-query?name=libredns.gr > /dev/null;
done
