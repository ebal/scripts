#!/bin/bash

############################
### Namespace:   ebal    ###
### veth gw: 10.10.10.10 ###
### dns:   88.198.92.222 ###
############################

ip netns exec ebal ip route add default via 10.10.10.10
sysctl -w net.ipv4.ip_forward=1
iptables --table nat --append POSTROUTING --source 10.0.0.0/8 --jump MASQUERADE
mkdir -p /etc/netns/ebal/
echo nameserver 88.198.92.222 > /etc/netns/ebal/resolv.conf
ip netns exec ebal ping -c 3 ipv4.balaskas.gr
ip netns exec ebal dig analytics.google.com +short
