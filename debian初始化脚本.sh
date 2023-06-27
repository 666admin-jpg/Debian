#! /bin/bash

echo "
Pleace write your want parameter:

Network card:
as: (ens33)
"
read card

echo "
Network type:
(static or DHCP)
"
read type

echo "
Network address: 
"
read address

echo "
Network mask:  
as: (/24)
"
read mask

echo "
hostname:
"
read hostname

hostnamectl set-hostname $hostname

timedatectl set-timezone Asia/Shanghai

cat > /etc/network/interfaces <<EOF 
auto $card
iface $card inet $type
address $address$mask
gateway 192.168.10.254
EOF

cat > /etc/resolv.conf <<EOF
nameserver 114.114.114.114
EOF

systemctl restart networking

ifup $card

rm /etc/apt/sources.list

cat > /etc/apt/sources.list <<EOF 
deb http://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free

deb http://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free

deb http://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free

deb http://security.debian.org/debian-security bullseye-security main contrib non-free
EOF

apt-cdrom add

apt update

apt install -y openssh-server vim

cat >> /etc/ssh/sshd_config <<EOF
permitrootlogin yes
EOF

systemctl restart sshd


