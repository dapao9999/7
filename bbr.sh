#!/bin/bash

fuser -k /dev/net/tun
# delete tap0
ip tuntap del dev tap0 mode tap

# add tap0
ip tuntap add dev tap0 mode tap
ip link set dev tap0 up
ip addr add dev tap0 10.0.0.1/24
sysctl -w net.ipv4.ip_forward=1
iptables -P FORWARD ACCEPT

# delete old iptables rules
iptables -t nat -D POSTROUTING -o venet0 -j MASQUERADE
iptables -t nat -D PREROUTING -i venet0 -p tcp --dport 443 -j DNAT --to-destination 10.0.0.2
iptables -t nat -D PREROUTING -i venet0 -p tcp --dport 80 -j DNAT --to-destination 10.0.0.2

# add iptables rules
iptables -t nat -A POSTROUTING -o venet0 -j MASQUERADE
iptables -t nat -A PREROUTING -i venet0 -p tcp --dport 443 -j DNAT --to-destination 10.0.0.2
iptables -t nat -A PREROUTING -i venet0 -p tcp --dport 80 -j DNAT --to-destination 10.0.0.2

LD_PRELOAD="/root/lkl/liblkl-hijack_patched.so" LKL_HIJACK_NET_QDISC="root|fq" LKL_HIJACK_SYSCTL='net.ipv4.tcp_congestion_control="bbr";net.ipv4.tcp_wmem="4096 16384 30000000"' LKL_HIJACK_NET_IFTYPE="tap" LKL_HIJACK_NET_IFPARAMS="tap0" LKL_HIJACK_NET_IP="10.0.0.2" LKL_HIJACK_NET_NETMASK_LEN="24" LKL_HIJACK_NET_GATEWAY="10.0.0.1" LKL_HIJACK_OFFLOAD="0x8883" $* &

exit
