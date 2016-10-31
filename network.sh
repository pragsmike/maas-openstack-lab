CONTAINER=maas
MASTER=cluster

lxc file push - $CONTAINER/etc/network/interfaces.d/vlans.cfg <<EOF

# Internal interface (managed; isolated network) - used for nodes
#auto $MASTER
#iface $MASTER inet static
#    address 10.14.0.1/20

# admin-api managed subnet on VLAN 150
auto $MASTER.150
iface $MASTER.150 inet static
    address 10.150.0.1/20
    vlan-raw-device $MASTER

# internal-api managed subnet on VLAN 100
auto $MASTER.100
iface $MASTER.100 inet static
    address 10.100.0.1/20
    vlan-raw-device $MASTER

# public-api managed subnet on VLAN 50
auto $MASTER.50
iface $MASTER.50 inet static
    address 10.50.0.1/20
    vlan-raw-device $MASTER

# compute-data managed subnet on VLAN 250
auto $MASTER.250
iface $MASTER.250 inet static
    address 10.250.0.1/20
    vlan-raw-device $MASTER

# compute-external managed subnet on VLAN 99
auto $MASTER.99
iface $MASTER.99 inet static
    address 10.99.0.1/20
    vlan-raw-device $MASTER

# storage-data managed subnet on VLAN 200
auto $MASTER.200
iface $MASTER.200 inet static
    address 10.200.0.1/20
    vlan-raw-device $MASTER

# storage-cluster managed subnet on VLAN 30
auto $MASTER.30
iface $MASTER.30 inet static
    address 10.30.0.1/20
    vlan-raw-device $MASTER
EOF
