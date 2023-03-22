#!/bin/bash

# Check if kernel version is greater than or equal to 4.9
if [[ $(uname -r | cut -d "." -f 1) -lt 4 || $(uname -r | cut -d "." -f 2) -lt 9 ]]; then
    echo "Error: Kernel version must be greater than or equal to 4.9"
    exit 1
fi

# Enable BBR
sudo bash -c 'echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf'
sudo bash -c 'echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf'
sudo sysctl -p

# Check if BBR is enabled
if [[ $(sysctl net.ipv4.tcp_available_congestion_control | awk '{print $NF}') != "bbr" || $(sysctl net.ipv4.tcp_congestion_control | awk '{print $NF}') != "bbr" ]]; then
    echo "Error: Failed to enable BBR."
    exit 1
fi

echo "BBR has been successfully enabled."
exit 0
