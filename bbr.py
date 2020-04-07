import subprocess

with open('/etc/sysctl.conf','a') as f:
    f.write('net.core.default_qdisc=fq\nnet.ipv4.tcp_congestion_control=bbr\n')

subprocess.Popen(['sysctl','-p'])
subprocess.Popen(['cat','/etc/sysctl.conf'])
