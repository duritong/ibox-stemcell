#!/bin/sh

date > /etc/ibox_build_time

yum -y update
rkhunter --propupdate

shutdown -r +2

exit
