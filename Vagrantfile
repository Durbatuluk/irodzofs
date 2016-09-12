require 'fileutils'
require 'ipaddr'

Vagrant.require_version ">= 1.6.0"

VAGRANTFILE_API_VERSION = "2"
CONFIG = File.join(File.dirname(__FILE__), "config.rb")

ENV['VAGRANT_DEFAULT_PROVIDER'] = 'virtualbox'

# Defaults for config options defined in CONFIG

$num_instances = 3
$instance_name_prefix = "irodzofs"
$share_home = false
$vm_gui = false
$vm_memory = 1024
$vm_cpus = 1
$vm_starting_ip = "172.17.8.100"

if File.exist?(CONFIG)
    require CONFIG
end

$vm_ip = $vm_starting_ip

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.box = "ubuntu/trusty64"
    config.ssh.insert_key = true
    config.ssh.forward_agent = true
    config.ssh.forward_x11 = true

    if Vagrant.has_plugin?("vagrant-cachier")
        config.cache.scope = :box
    end

    (1..$num_instances).each do |i|
    
        config.vm.define vm_name = "%s-%02d" % [$instance_name_prefix, i] do |config|
            config.vm.hostname = vm_name

            # just split out the ip

            ip = IPAddr.new($vm_ip)
            $vm_ip = ip.succ.to_s
            config.vm.network :private_network, ip: $vm_ip 
        end
    end

    config.vm.provider :virtualbox do |vb|
        vb.gui = $vm_gui
        vb.memory = $vm_memory
        vb.cpus = $vm_cpus
    end


    config.vm.provision "shell", privileged: true, inline: <<-SHELL
        export DEBIAN_FRONTEND=noninteractive
        [ -e /usr/lib/apt/methods/https ] || {
            apt-get -qqy update
            apt-get -qqy install apt-transport-https ca-certificates
        }

        # Make sure the package repository is up to date and install required packages
        apt-get -y update && apt-get install -y \
        wget \
        lsb-release
        
        # Avoid warning during packet installations
        ENV DEBIAN_FRONTEND noninteractive
        echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d
        
        # Set the Docker repository to access Docker packages
        apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
        echo "deb https://apt.dockerproject.org/repo ubuntu-$(lsb_release -sc) main" | tee /etc/apt/sources.list.d/docker.list
        
        # Set the RozoFS repository to access RozoFS packages
        wget -O - http://dl.rozofs.org/deb/devel@rozofs.com.gpg.key | apt-key add -
        echo "deb http://dl.rozofs.org/deb/master $(lsb_release -sc)  main" | tee /etc/apt/sources.list.d/rozofs.list
        
        # Install rozofsmount required to mount the remote volume locally and others required packages
        apt-get -y update && apt-get install -y \
        rozofs-manager* rozofs-rozofsmount rsyslog git make vim docker docker-engine postgresql libcurl4-gnutls-dev 
     
    SHELL
end
