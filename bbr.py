import os
with open('/etc/sysctl.conf', 'a') as f:
	f.write('net.core.default_qdisc=fq\nnet.ipv4.tcp_congestion_control=bbr\n')
os.system('sysctl -p')
