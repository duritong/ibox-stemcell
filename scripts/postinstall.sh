#!/bin/sh

date > /etc/ibox_build_time

yum -y update
rkhunter --propupdate

# things for vagrant
# needs sudo over ssh
sed -i "s/^Defaults    requiretty/#Defaults    requiretty/" /etc/sudoers
# rsync to sync folders
yum install rsync -y
