#!/bin/bash

cd /var/www
sudo chown -R $USER html/
sudo rm -rf html
sudo mkdir html
sudo chown -R $USER html/
cd html
sudo git clone https://github.com/theoafactor/SimplePersonal.git .