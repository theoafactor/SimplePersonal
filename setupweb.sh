#!/bin/bash

cd /var/www
sudo chown -R $USER html/
sudo rm -rf html
sudo mkdir html
cd html
git clone https://github.com/theoafactor/SimplePersonal.git .