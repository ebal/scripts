#!/usr/bin/env python3

import dns.message
import requests
import base64
import sys

RRs = ('A', 'AAAA', 'CNAME')

if len(sys.argv) != 3:
    print("Usage: python3 RFC.8484.py balaskas.gr AAAA")
    sys.exit(1)

if sys.argv[2] not in RRs:
    print("Supported Reourse Records: A, AAAA & CNAME")
    sys.exit(1)

message = dns.message.make_query(sys.argv[1], sys.argv[2])
dns_req = base64.b64encode(message.to_wire()).decode('UTF8').rstrip('=')

url = "https://doh.libredns.gr/dns?dns=" + dns_req
# url = "https://cloudflare-dns.com/dns-query?dns=" + dns_req
# url = "https://dns.google/dns-query?dns=" + dns_req

r = requests.get(url, headers={"Content-type": "application/dns-message"})

for answer in dns.message.from_wire(r.content).answer:
    print(answer.to_text().split()[-1])

