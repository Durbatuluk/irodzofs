#!/bin/bash

#install iRODS
wget ftp://ftp.renci.org/pub/irods/releases/4.1.8/ubuntu14/irods-database-plugin-postgres-1.8-ubuntu14-x86_64.deb -O /tmp/irods-dbplugin.deb
wget ftp://ftp.renci.org/pub/irods/releases/4.1.8/ubuntu14/irods-icat-4.1.8-ubuntu14-x86_64.deb -O /tmp/irods-icat.deb


apt-get install -y `dpkg -I /tmp/irods-icat.deb | sed -n 's/^ Depends: //p' | sed 's/,//g'`
dpkg -i /tmp/irods-icat.deb

apt-get install -y `dpkg -I /tmp/irods-dbplugin.deb | sed -n 's/^ Depends: //p' | sed 's/,//g'`
dpkg -i /tmp/irods-dbplugin.deb

mkdir /opt/irods

mv genresp.sh /opt/irods/genresp.sh
mv setupdb.sh /opt/irods/setupdb.sh
mv config.sh /opt/irods/config.sh
mv bootstrap.sh /opt/irods/bootstrap.sh
chmod a+x /opt/irods/*.sh

echo "172.17.8.102 irodzofs-02 irodzofs-02" >> /etc/hosts
