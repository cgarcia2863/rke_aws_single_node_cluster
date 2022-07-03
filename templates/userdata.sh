#!/bin/bash
yum install -y docker
systemctl enable docker
systemctl start docker
usermod -aG docker ec2-user
sysctl -w net.bridge.bridge-nf-call-iptables=1
sed -i 's/#AllowTcpForwarding yes/AllowTcpForwarding yes/g' /etc/ssh/sshd_config