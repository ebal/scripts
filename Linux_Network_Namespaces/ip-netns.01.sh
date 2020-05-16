#!/bin/bash

###########################
### Namespace: ebal     ###
### v-eth0: 10.10.10.10 ###
### v-ebal: 10.10.10.20 ###
###########################

ip netns add ebal
ip link add v-eth0 type veth peer name v-ebal
ip link set v-ebal netns ebal
ip addr add 10.10.10.10/24 dev v-eth0
ip netns exec ebal ip addr add 10.10.10.20/24 dev v-ebal
ip link set v-eth0 up
ip netns exec ebal ip link set v-ebal up
ping -c3  10.10.10.20
ip netns exec ebal ping -c3  10.10.10.10
