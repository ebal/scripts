#!/usr/bin/env python3

# ./RFC.8484.py balaskas.gr A

import dns.message
import base64
import requests
import sys

message = dns.message.make_query( sys.argv[1] , sys.argv[2] )
dns_req = base64.urlsafe_b64encode(message.to_wire()).decode('UTF8').rstrip('=')

url = "https://doh.libredns.gr/dns/?dns=" + dns_req

r = requests.get(
        url,
        headers={"Content-type": "application/dns-message"}
    )

for answer in dns.message.from_wire( r.content ).answer:
    print(answer.to_text().split()[-1])
