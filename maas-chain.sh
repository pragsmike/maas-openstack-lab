#!/bin/bash
# If you happen to already have a MAAS instance,
# you can use it to provision a second MAAS server.
# Acquire the system that is to become the new maas,
# then run this script.  Change the SYSTEM_ID
# to whatever the existing MAAS thinks your NUC is.
#
# The target machine is a NUC5 with 8G RAM, 250GB disk.
#
# It is intended to be a MAAS controller itself.
#
SYSTEM_ID=76yxmm

maas maas partitions create $SYSTEM_ID sda size=500M
maas maas partition format $SYSTEM_ID sda sda-part1 fstype=fat32
maas maas partition mount  $SYSTEM_ID sda sda-part1 mount_point=/boot/efi

maas maas partitions create $SYSTEM_ID sda size=10G
maas maas partition format $SYSTEM_ID sda sda-part2 fstype=ext4
maas maas partition mount  $SYSTEM_ID sda sda-part2 mount_point=/

maas maas partitions create $SYSTEM_ID sda size=20G
maas maas partition format $SYSTEM_ID sda sda-part3 fstype=ext4
maas maas partition mount  $SYSTEM_ID sda sda-part3 mount_point=/var

maas maas partitions create $SYSTEM_ID sda size=20G
maas maas partition format $SYSTEM_ID sda sda-part4 fstype=ext4
maas maas partition mount  $SYSTEM_ID sda sdc-part4 mount_point=/home

maas maas partitions create $SYSTEM_ID sda size=8G
