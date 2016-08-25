#!/bin/bash

#install packages required
apt-get install virtualbox \
    vagrant \

#install scp for vagrant
vagrant plugin install vagrant-scp

#install vagrant machines
vagrant up
./distribScripts.sh
