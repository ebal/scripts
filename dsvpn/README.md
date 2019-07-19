# Dead Simple VPN

## systemd

### Server

`/etc/systemd/system/dsvpn\_server.service`

```sh
systemctl daemon-reload
systemctl restart dsvpn\_server.service
```
### Client

`/etc/systemd/system/dsvpn\_client.service`

```sh
systemctl daemon-reload
systemctl restart dsvpn\_client.service
```

## IP addressing

### Server

`ip -4 addr show tun0`

```sh
3: tun0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 9000 qdisc fq_codel state UNKNOWN group default qlen 500
    inet 10.8.0.254 peer 10.8.0.2/32 scope global tun0
           valid_lft forever preferred_lft forever
```

### Client

`ip -4 addr show tun0`

```sh
3: tun0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 9000 qdisc fq_codel state UNKNOWN group default qlen 500
    inet 10.8.0.2 peer 10.8.0.254/32 scope global tun0
           valid_lft forever preferred_lft forever
```

## Connecting

### Server

`ping -c 5 10.8.0.2`

```sh
PING 10.8.0.2 (10.8.0.2) 56(84) bytes of data.
64 bytes from 10.8.0.2: icmp_seq=1 ttl=64 time=78.8 ms
64 bytes from 10.8.0.2: icmp_seq=2 ttl=64 time=73.3 ms
64 bytes from 10.8.0.2: icmp_seq=3 ttl=64 time=73.1 ms
64 bytes from 10.8.0.2: icmp_seq=4 ttl=64 time=74.2 ms
64 bytes from 10.8.0.2: icmp_seq=5 ttl=64 time=73.7 ms

--- 10.8.0.2 ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4006ms
rtt min/avg/max/mdev = 73.101/74.648/78.854/2.166 ms
```

### Client

`ping -c 5 10.8.0.254`

```sh
PING 10.8.0.254 (10.8.0.254) 56(84) bytes of data.
64 bytes from 10.8.0.254: icmp_seq=1 ttl=64 time=73.1 ms
64 bytes from 10.8.0.254: icmp_seq=2 ttl=64 time=74.0 ms
64 bytes from 10.8.0.254: icmp_seq=3 ttl=64 time=72.8 ms
64 bytes from 10.8.0.254: icmp_seq=4 ttl=64 time=73.0 ms
64 bytes from 10.8.0.254: icmp_seq=5 ttl=64 time=73.0 ms

--- 10.8.0.254 ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4005ms
rtt min/avg/max/mdev = 72.835/73.222/74.045/0.544 ms
```
