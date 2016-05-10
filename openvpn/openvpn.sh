#!/bin/sh

### openvpn running on TCP port 443 ###
SERVER_IP=1.2.3.4


yum -y install epel-release
yum -y install openvpn.x86_64

cd /etc/openvpn/

\rm -rf certs server.conf

cat > server.conf << EOF
# TCP Port 443
port 443
proto tcp
# Device
dev tun
# Certs
ca   certs/CA.crt
cert certs/server.crt
key  certs/server.key
dh   certs/dhp.pem
# Network
server 192.168.66.8 255.255.255.248
# DNS
push "dhcp-option DNS 8.8.8.8" 
# Gateway
# push "redirect-gateway def1"
# push "redirect-gateway local def1"
push "redirect-gateway def1 bypass dhcp"

# ifconfig-pool-persist ipp.txt

client-to-client
duplicate-cn

keepalive 10 120
comp-lzo
max-clients 3

user openvpn
group openvpn

persist-tun
persist-key

script-security 3
verb 0
EOF

mkdir certs
cd certs

for i in ca server client; do 

cat > $i.openssl.conf << EOF
[ req ]
default_bits            = 4096
distinguished_name      = req_distinguished_name
attributes              = req_attributes
prompt			= no
[ req_attributes ]
[ req_distinguished_name ]
C = GR
ST = Attica
L = Athens
O = Organization
OU = Organization Unit
CN = $i.common.name
emailAddress  = info@common.name
EOF

done

# Certificate Authority
openssl req -new -nodes -x509 -keyout CA.key -out CA.crt -days 1825 -newkey rsa:4096 -config ca.openssl.conf

# OpenVPN Server & Cleint Certificate Request
openssl req -new -nodes -keyout server.key -out server.csr -config server.openssl.conf 
openssl req -new -nodes -keyout client.key -out client.csr -config client.openssl.conf 

# Sign OpenVPN Server & Client Certificates with CA
openssl x509 -req -days 365 -in server.csr -out server.crt -sha256 -CA CA.crt -CAkey CA.key -set_serial 01
openssl x509 -req -days 365 -in client.csr -out client.crt -sha256 -CA CA.crt -CAkey CA.key -set_serial 01

# Generate DH parameters
# openssl pkeyparam -in dhp.pem -text
## openssl genpkey -genparam -algorithm DH -out dhp.pem -pkeyopt dh_paramgen_prime_len:2048 
openssl dhparam -out dhp.pem 2048

# File pems
chmod 0400 *key *csr *crt

cat > client.ovpn << EOF
client
connect-retry-max 5
connect-retry 5
remote ${SERVER_IP} 443
nobind
resolv-retry infinite
proto tcp
dev tun
persist-key
persist-tun
# fast-io
# comp-lzo
script-security 2
mute-replay-warnings

<ca>
`cat CA.crt`
</ca>

<cert>
`cat client.crt`
</cert>

<key>
`cat client.key`
</key>

EOF

