#!/bin/bash
# Run this on the NUC.  It sets up the admin user, installs LXD,
# and prepares to host the MAAS container.
# The admin user on the NUC will be given a copy of the SSH
# credentials from the ubuntu user on the machine where you run this.
#
# Override these defaults by creating a file called config

HOSTNAME=maas
ADMIN_IP4=10.0.0.2
ADMIN_IP4_CIDR=10.0.0.2/24
LXD_PASS=secret
ADMIN_GATEWAY=10.0.0.1
ADMIN_DNS=10.0.0.1
ADMIN_DOMAIN=admin-domain
ADMIN_USER=admin
ADMIN_PASS=encrypted-password

. config

echo $HOSTNAME > /etc/hostname
hostname $HOSTNAME

useradd -m $ADMIN_USER -G sudo -s /bin/bash -p $ADMIN_PASS
cp -a ~ubuntu/.ssh /home/$ADMIN_USER
chown -R ${ADMIN_USER}.${ADMIN_USER} /home/$ADMIN_USER/.ssh

apt update
apt upgrade -y

# Make sure it boots from local disk next time
grub-install


apt install -y zfsutils-linux lxd

ifdown enp3s0

cat >/etc/network/interfaces <<EOF
auto lo
iface lo inet loopback
    dns-nameservers $ADMIN_DNS
    dns-search $ADMIN_DOMAIN

auto br-admin
iface br-admin inet static
    dns-nameservers $ADMIN_DNS
    dns-search $ADMIN_DOMAIN
    address $ADMIN_IP4_CIDR
    gateway $ADMIN_GATEWAY
    mtu 1500
    bridge_ports enp3s0
    bridge_stp off

source /etc/network/interfaces.d/*.cfg
EOF

#systemctl restart networking
ifup br-admin

# Create a partition that fills the largest unused space
sgdisk -N 0 /dev/sda
partprobe
vgcreate bulk /dev/sda6

lvcreate -n lxd -l 100%VG bulk

lxd init --auto \
    --network-address $ADMIN_IP4 \
    --network-port 8443 \
    --storage-backend zfs \
    --storage-create-device /dev/mapper/bulk-lxd \
    --storage-pool lxd \
    --trust-password $LXD_PASS

apt install criu
lxc config set core.https_address [::]:8443
lxc config set core.trust_password $LXD_PASS

lxc image copy ubuntu:16.04 local: --alias ubuntu-xenial
