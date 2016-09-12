#!/bin/bash

cd docker-fs
make images
./start_cluster.sh
./add_client.sh
mkdir /mnt/rozofs
chmod 777 /mnt/rozofs
./mount_cluster.sh /mnt/rozofs
#docker exec -it rozofs-client01 bash
