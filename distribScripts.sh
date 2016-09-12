#!/bin/bash

# Copier script iCat sur machine 1
vagrant scp irodsUtils/iCat irodzofs-01:/home/vagrant
vagrant scp dockerfs irodzofs-01:/home/vagrant

# Copier script iRes sur machine 2
vagrant scp irodsUtils/iRes irodzofs-02:/home/vagrant
vagrant scp dockerfs irodzofs-02:/home/vagrant

# Copier script iCli sur machine 3
vagrant scp irodsUtils/iCli irodzofs-03:/home/vagrant
