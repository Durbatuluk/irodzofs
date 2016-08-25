#!/bin/bash

wget ftp://ftp.renci.org/pub/irods/releases/4.1.8/ubuntu14/irods-icommands-4.1.8-ubuntu14-x86_64.deb -O /tmp/icommands.deb
apt-get install -y `dpkg -I /tmp/icommands.deb | sed -n 's/^ Depends: //p' | sed 's/,//g'`
dpkg -i /tmp/icommands.deb
cd
mkdir .irods
mv ~/iCli/irods_environment.json ~/.irods/irods_environment.json
