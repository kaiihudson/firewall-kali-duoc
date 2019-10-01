#!/bin/bash

#FLUSH GENERAL
iptables -F
iptables -X
iptables -Z
#FLUSH NAT
iptables -t nat -F

#POLITICA INSEGURA POR DEFECTO
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT

#POLITICA NAT INSEGURA POR DEFECTO
iptables -t nat -P PREROUTING ACCEPT
iptables -t nat -P POSTROUTING ACCEPT

#POLITICAS IN
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -s 192.168.50.0/24 -i eth1 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -s 0.0.0.0/0 -p tcp --dport 1:1024 -j DROP
iptables -A INPUT -s 0.0.0.0/0 -p udp --dport 1:1024 -j DROP
iptables -A INPUT -s 0.0.0.0/0 -p tcp --dport 10000 -j DROP
iptables -P INPUT DROP

#POLITICAS FORWARD
iptables -A FORWARD -s 192.168.50.0/24 -i eth1 -p tcp --dport 80 -j ACCEPT
iptables -A FORWARD -s 192.168.50.0/24 -i eth1 -p tcp --dport 443 -j ACCEPT
iptables -A FORWARD -s 192.168.50.0/24 -i eth1 -p tcp --dport 53 -j ACCEPT
iptables -A FORWARD -s 192.168.50.0/24 -i eth1 -p udp --dport 53 -j ACCEPT
iptables -A FORWARD -s 192.168.50.0/24 -i eth1 -j DROP
iptables -P FORWARD DROP

#POLITICAS OUT

#POLITICAS PRE
iptables -t nat -A POSTROUTING -s 192.168.50.0/24 -o eth0 -j MASQUERADE
iptables -t nat -P POSTROUTING DROP
#POLITICAS POST

#FIN
iptables -L -n && sleep 5
echo "------------------------------"
iptables -t nat -L -n && sleep 5
echo "------------------------------"
echo "revise que la configuracion este correcta"
