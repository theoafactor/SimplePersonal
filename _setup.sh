#!/bin/bash


# install runner
mkdir actions-runner 

## configure 
sudo chown -R $USER actions-runner/

cd actions-runner

curl -o actions-runner-linux-x64-2.313.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.313.0/actions-runner-linux-x64-2.313.0.tar.gz

sudo chown -R $USER actions-runner/*

tar xzf ./actions-runner-linux-x64-2.313.0.tar.gz

sudo chown -R $USER actions-runner/*

#Add Docker's official GPG key:
./config.sh --unattended --url https://github.com/theoafactor/SimplePersonal --token ADKQKWNQ7OYBSVAPNO3B2TTF5SS32 --replace

sudo ./svc.sh install 

sudo ./svc.sh start


# install Docker
#Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y


## Create New Users 
# - jamesuser 


sudo useradd jamesuser

# set the password for jamesuser
sudo echo "jamesuser:jamesuser" | sudo chpasswd

# create the no group
sudo groupadd nosu


sudo usermod -aG nosu jamesuser


sudo chown $USER /etc/pam.d/su 

sudo rm -f /etc/pam.d/su

sudo touch /etc/pam.d/su

sudo chown $USER /etc/pam.d/su

sudo cat > /etc/pam.d/su << EOL
#
# The PAM configuration file for the Shadow 'su' service
#
# This allows root to su without passwords (normal operation)
#auth       sufficient pam_rootok.so

# Uncomment this to force users to be a member of group wheel
# before they can use 'su'. You can also add "group=foo"
# to the end of this line if you want to use a group other
# than the default "wheel" (but this may have side effect of
# denying "root" user, unless she is a member of "foo" or explicitly
# permitted earlier by e.g. "sufficient pam_rootok.so").
# (Replaces the 'SU_WHEEL_ONLY' option from login.defs)
# auth       required   pam_wheel.so
# Uncomment this if you want wheel members to be able to
# su without a password.
# auth       sufficient pam_wheel.so trust
# Uncomment this if you want members of a specific group to not
# be allowed to use su at all.54.196.106.38
auth       required   pam_wheel.so deny group=nosu
# Uncomment and edit /etc/security/time.conf if you need to set
# time restrainst on su usage.
# (Replaces the 'PORTTIME_CHECKS_ENAB' option from login.defs
# as well as /etc/porttime)
# account    requisite  pam_time.so
# This module parses environment configuration file(s)
# and also allows you to use an extended config
# file /etc/security/pam_env.conf.
# 
# parsing /etc/environment needs "readenv=1"
session       required   pam_env.so readenv=1
# locale variables are also kept into /etc/default/locale in etch
# reading this file *in addition to /etc/environment* does not hurt
session       required   pam_env.so readenv=1 envfile=/etc/default/locale

# Defines the MAIL environment variable
# However, userdel also needs MAIL_DIR and MAIL_FILE variables
# in /etc/login.defs to make sure that removing a user 
# also removes the user's mail spool file.
# See comments in /etc/login.defs
#
# "nopen" stands to avoid reporting new mail when su'ing to another user
session    optional   pam_mail.so nopen

# Sets up user limits according to /etc/security/limits.conf
# (Replaces the use of /etc/limits in old login)
session    required   pam_limits.so

# The standard Unix authentication modules, used with
# NIS (man nsswitch) as well as normal /etc/passwd and
# /etc/shadow entries.
@include common-auth
@include common-account
@include common-session
EOL

