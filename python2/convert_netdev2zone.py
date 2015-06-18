#!/usr/bin/python2.6
# Create a new bind dns zone from auto-discovered network devices
# Clean up previous entries (if exists) and append the new ones

"""
Sample Data
 athe_7609a,10.20.30.117,.1.3.6.1.4.1.9.1.516,DNS_UNKNOWN,Cisco
 athe_7609b,10.20.40.120,.1.3.6.1.4.1.9.1.516,DNS_UNKNOWN,Cisco

Sample Output
 athe_7609a              IN        A         10.20.30.117
 athe_7609b              IN        A         10.20.40.120
"""

import time
import re

# Variables
src_file = "/opt/backup/new_network_devices"
dst_file = "/var/named/routers.example.gr"

new_routers = [ ]
prev_hosts  = [ ]

# Open src file to find the new routers 
with open ( src_file ) as f:
    for line in f:
        # skip lines with reverse IP
        if "DNS_UNKNOWN" not in line: continue

        # Convert line to lower case
        line = line.lower()
        # Remove carriage return
        line = line.replace('\n', '')

        # split line into parts
        line_parts = line.split(',')

        # Dont accept underscore in hostname
        if "_" in line_parts[0]: 
            continue
        else:
            new_routers.append ( [ line_parts[0], line_parts[1] ] )

# Create a list with only IPs
ips = [ r[1] for r in new_routers ]

# Open dst file to find the old hosts
with open ( dst_file ) as f:
    for line in f:

        # Replace line
        line = re.sub('\t+',' ', line)
        line = re.sub(' +',' ', line)
        line = re.sub(' ','\t', line)

        # bypass empty lines
        line = line.replace ( '\n', '' )
        if line in ['\n', '\r\n']: 
            continue

        # Split line to parts
        line_parts = line.split('\t')
 
        # Get the Serial
        if "Serial" in line:
            # Convert Serial to integer
            serial = int ( line_parts[1] )
            # Create the New Serial
            new_serial = int ( time.strftime("%Y%m%d") + "01" ) 
            # Compare them
            if new_serial <= serial:
                new_serial = serial + 1 ;
            print "\t" + str ( new_serial ) + "\t\t;\tSerial "
            continue

        # Create a list with the existing hosts
        if ( line_parts[-1] in ips ):
            prev_hosts.append ( line_parts[0] )
            continue
        # bypass CNAMEs based on the prev_hosts
        if len(prev_hosts) > 0 and prev_hosts.pop() in line: 
            continue 

        print line

print ";"
print ";" + time.strftime("%Y-%m-%d %H:%M:%S")
print ";"

for r in new_routers:
    print r[0] + "\tIN\tA\t" + r[1]

print ";"
print ";" + time.strftime("%Y-%m-%d %H:%M:%S")
print ";"

# vim: tabstop=4 expandtab shiftwidth=4 softtabstop=4
