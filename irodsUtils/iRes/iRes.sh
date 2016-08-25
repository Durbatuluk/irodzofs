#!/bin/bash

wget ftp://ftp.renci.org/pub/irods/releases/4.1.8/ubuntu14/irods-resource-4.1.8-ubuntu14-x86_64.deb -O /tmp/irods-ires.deb

apt-get install -y `dpkg -I /tmp/irods-ires.deb | sed -n 's/^ Depends: //p' | sed 's/,//g'`
dpkg -i /tmp/irods-ires.deb

echo "172.17.8.101 irodzofs-01 irodzofs-01" >> /etc/hosts
