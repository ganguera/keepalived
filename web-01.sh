#!/usr/bin/env bash

# Install packages
yum install -y epel-release
yum install -y nginx iptables-services

# Enable and run nginx
systemctl start nginx
systemctl enable nginx

# Disable firewalld
systemctl stop firewalld
systemctl mask firewalld

# Configure Keepalived Direct Routing
iptables -t nat -A PREROUTING -p tcp -d 172.16.10.10 --dport 80 -j REDIRECT
iptables-save > /etc/sysconfig/iptables
systemctl enable iptables.service

# Raise nf_conntrack
cat << EOF > /etc/sysctl.d/90-nf_conntrack.conf
net.netfilter.nf_conntrack_max = 500000

EOF

sysctl -p --system
