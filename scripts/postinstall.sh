#!/bin/sh

date > /etc/ibox_build_time

yum -y update

# things for vagrant
# needs sudo over ssh
sed -i "s/^Defaults    requiretty/#Defaults    requiretty/" /etc/sudoers

rkhunter --propupdate
