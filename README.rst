--------------
About iRodzoFS
--------------

The iRodzoFS project is a testing platform for RozoFS integration in iRODS environment.

RozoFS
======

RozoFS is a scale-out distributed file system providing high performance and high availability since it relies on an erasure code based on the Mojette transform. User data is projected into several chunks and distributed across storage devices. While data can be retrieved even if several pieces are unavailable, chunks are meaningless alone. Erasure coding brings the same protection as plain replication but reduces the amount of stored data by two.

iRODS
=====

The Integrated Rule-Oriented Data System (iRODS) is open source data management software for storing, searching, organizing, and sharing files and datasets that are large, important, and complex. Thousands of businesses, research centers, and government agencies worldwide use iRODS for flexible, policy-based management of files and metadata that span storage devices and locations.

Platform
========

The platform is built using ``vagrant`` to create the virtuals machines. The RozoFS storage solution deployment uses ``docker``. The goal of the platform is to show how RozoFS interacts with the iRODS environment.

About Vagrant
-------------

Vagrant provides easy to configure, reproducible, and portable work environments built on top of industry-standard technology and controlled by a single consistent workflow to help maximize the productivity and flexibility of you and your team. To achieve its magic, Vagrant stands on the shoulders of giants. Machines are provisioned on top of VirtualBox, VMware, AWS, or any other provider. Then, industry-standard provisioning tools such as shell scripts, Chef, or Puppet, can be used to automatically install and configure software on the machine.


About Docker
------------

Docker is an open platform for developers and sysadmins to build, ship, and run distributed applications. Consisting of Docker Engine, a portable, lightweight runtime and packaging tool, and Docker Hub, a cloud service for sharing applications and automating workflows, Docker enables apps to be quickly assembled from components and eliminates the friction between development, QA, and production environments. As a result, IT can ship faster and run the same app, unchanged, on laptops, data center VMs, and any cloud.


-------------------
Installing iRodzoFS
-------------------

Get the project from Git
========================

.. code-block:: bash

	$ cd
	$ mkdir iRodzoFS
	$ cd iRodzoFS
	$ git clone https://github.com/Durbatuluk/irodzofs.git .


Init the project
================

.. code-block:: bash

	$ ./init.sh
	
This script will install these packages :

-  ``virtualbox``

-  ``vagrant``

It will also install the Vagrant plugin :

- ``vagrant-scp``

Then it will use the following commands to launch the platform :

.. code-block:: bash

	$ vagrant up
	$ ./distribScripts.sh

Now you can connect to your 3 differents machines using (on 3 differents shells) :

.. code-block:: bash

	$ vagrant ssh irodzofs-01
	$ vagrant ssh irodzofs-02
	$ vagrant ssh irodzofs-03


Installing RozoFS in Docker
===========================

You have to use the following command on these two machines : ``irodzofs-01`` and ``irodzofs-02`` :

.. code-block:: bash

	$ sudo -s
	$ cd
	$ cd docker-fs
	$ ./launch.sh


Installing iRods
================


Install and configure iCAT server
---------------------------------

Install iCat server
~~~~~~~~~~~~~~~~~~~

On ``irodzofs-01`` :

.. code-block:: bash

	$ sudo -s
	$ cd
	$ cd iCat
	$ ./iCat.sh	

	
Install iCat database
~~~~~~~~~~~~~~~~~~~~~

On ``irodzofs-01`` :

.. code-block:: bash

	$ su - postgres
	$ psql
	$ CREATE USER irods WITH PASSWORD 'root';
	$ CREATE DATABASE "ICAT";
	$ GRANT ALL PRIVILEGES ON DATABASE "ICAT" TO irods;
	$ \q
	$ exit

	
Configure iCat server
~~~~~~~~~~~~~~~~~~~~~

On ``irodzofs-01`` :

.. code-block:: bash

	$ sudo /var/lib/irods/packaging/setup_irods.sh
	

You will have to fill a list of parameters. The default value is specified inside [] : press ``Enter`` to use it.
I will write "default" if I advice you to use the default value.

.. code-block:: bash
	
	iRODS service account name [irods]: default
	iRODS service group name [irods]: default
	iRODS server zone name [tempZone]: Rozone
	iRODS server port [1247]: default
	iRODS port range (begin) [20000]: default
	iRODS port range (end) [20199]: default
	iRODS Vault directory [/var/lib/irods/iRODS/Vault]: /mnt/rozofs
	iRODS server zone_key [TEMPORARY_zone_key]: default
	iRODS server negotiation_key [TEMPORARY_32byte_negotiation_key]: default
	Control Plane port [1248]: default
	Control Plane key [TEMPORARY__32byte_ctrl_plane_key]: default
	Schema Validation Base URI (or 'off') [https://schemas.irods.org/configuration]: default
	iRODS server administrator username [rods]: default
	iRODS server administrator password: root
	

After you confirmed the settings, you will configure the database :

.. code-block:: bash

	Database server hostname or IP address: localhost
	Database server port [5432]: default
	Database name [ICAT]: default
	Database username [irods]:
	Database password: root

Just confirm the settings.


Configure iDrop WEB
~~~~~~~~~~~~~~~~~~~

Fill the file ``/etc/idrop-web/idrop-web-config2.groovy`` like this :

.. code-block:: bash 
	adress to connect : http://172.17.8.101:8080/idrop-web2
	idrop.config.preset.host="172.17.8.101"
	idrop.config.preset.port="1247"
	idrop.config.preset.zone="Rozone"
	idrop.config.preset.resource="demoResc"
	// can be Standard or PAM right now
	idrop.config.preset.authScheme="Standard"
	
Don't forget to use your own resource and zone names if you didn't configure iRODS like in this doc. Then, restart ``tomcat6`` service :

.. code-block:: bash

	$ sudo -s
	$ service tomcat6 restart

Connect to iCAT server
~~~~~~~~~~~~~~~~~~~~~~

You need to connect as an iRods user to use iRods fonctionalities :

.. code-block:: bash

	$ su - irods
	

Install and configure iRES server
---------------------------------

Install iRes server
~~~~~~~~~~~~~~~~~~~

On ``irodzofs-02`` :

.. code-block:: bash

	$ sudo -s
	$ cd
	$ cd iRes
	$ ./iRes.sh	
	

Configure iRes server
~~~~~~~~~~~~~~~~~~~~~

On ``irodzofs-02`` :

.. code-block:: bash

	$ sudo /var/lib/irods/packaging/setup_irods.sh

You will have to fill a list of parameters. The default value is specified inside [] : press ``Enter`` to use it.
I will write "default" if I advice you to use the default value.

.. code-block:: bash
	
	iRODS service account name [irods]: default
	iRODS service group name [irods]: default
	iRODS server port [1247]: default
	iRODS port range (begin) [20000]: default
	iRODS port range (end) [20199]: default
	iRODS Vault directory [/var/lib/irods/iRODS/Vault]: /mnt/rozofs
	iRODS server zone_key [TEMPORARY_zone_key]: default
	iRODS server negotiation_key [TEMPORARY_32byte_negotiation_key]: default
	Control Plane port [1248]: default
	Control Plane key [TEMPORARY__32byte_ctrl_plane_key]: default
	Schema Validation Base URI (or 'off') [https://schemas.irods.org/configuration]: default
	iRODS server administrator username [rods]: default
	

After you confirmed the settings, you will configure the communication with the iCAT server :

.. code-block:: bash

	iCAT server hostname: 172.17.8.101
	iCAT server's ZoneName: Rozone
	

Just confirm the settings and fill these :
	
.. code-block:: bash

	iCAT server admin username: rods
	iCAT server admin password: root
	

Connect to iRES server
~~~~~~~~~~~~~~~~~~~~~~

You need to connect as an iRods user to use iRods fonctionnalities :

.. code-block:: bash

	$ su - irods
	
Configure the resource
~~~~~~~~~~~~~~~~~~~~~~

We will use a basic iRods command to rename the iRES server's resource for easier management :

.. code-block:: bash

	$ iadmin modresc irodzofs-02Resource name demoResc2

Answer yes and then update the user configuration file :

.. code-block:: bash

	$ vim /var/lib/irods/.irods/irods_environment.json
	
Find and fill the line like this :

``"irods_default_resource": "demoResc2",``

Update the server configuration file :

.. code-block:: bash

	$ vim /etc/irods/server_config.json
	
Find and fill the line like this : 

``"default_resource_name" : "demoResc2"``


Install and configure iCLI machine
----------------------------------

Install iCli machine
~~~~~~~~~~~~~~~~~~~~

On ``irodzofs-03`` :

.. code-block:: bash

	$ sudo -s
	$ cd
	$ cd iCli
	$ ./iCli.sh	

Configure iCli machine
~~~~~~~~~~~~~~~~~~~~~~

The ``iCat.sh`` script create automatically a configuration file. If you follow this guide step by step without changing anything, you should not modify the configuration file. If you changed ``Zone's name`` or ``Resource's name`` in your iCAT server, you must edit and fill the configuration file :

.. code-block:: bash

	$ vim ~/.irods/irods_environment.json
	
Launch iDrop
~~~~~~~~~~~~

To launch the iDrop GUI :

.. code-block:: bash

	$ cd /var/lib/irods/iDrop
	$ ./iDrop.sh
	
To launch the iDrop WEB :

.. code-block:: bash

	$ firefox http://172.17.8.101:8080/idrop-web2
	
	