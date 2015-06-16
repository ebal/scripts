#!/usr/bin/python

file = "/etc/aliases"

# Open file
with open(file) as f:
    for line in f:

        # Ignore Comment lines
        if '#' in line: continue
        # Ignore empty lines
        if line in ['\n', '\r\n']: continue
        # Ignore aliases that point to /dev/null
        if "/dev/null" in line: continue
        # Ignore Custom script for auto-respond
        if "autoresponder" in line: continue

        # Replace special characters
        line = line.replace('\n', '')
        line = line.replace('\\', '')
        line = line.replace('\|','')
        line = line.replace(' ', '')

        # Convert everything to lowercase
        l = line.lower()

        # Converting aliases-MX
        # eg. mailling_list: user1,user2@example.com,user3@example.org
        # primary domain: example.gr

        # Email Address -> eml_parts[0]
        eml_parts = l.split(':')
        # Forward Addresses
        fwd_parts = eml_parts[1].split(',')

        # Print ldif
        print "dn: uid=" + eml_parts[0] + ",ou=people,dc=example,dc=gr"
        print "uid: " + eml_parts[0]
        # Custom ldap objectClass
        print """objectClass: account
objectClass: exampleAccount
objectClass: exampledistributionlist
objectClass: top
exampleDomainDN: dc=example,dc=gr"""
        print "mail: " + eml_parts[0] + "@example.gr"
        for f in fwd_parts:
            # Convert user to user@example.gr
            if '@' not in f:
                f = f + '@example.gr'
            print 'forwardTo: %s' % f
        print
        print
        print 

# vim: tabstop=4 expandtab shiftwidth=4 softtabstop=4
