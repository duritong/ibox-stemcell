# kickstart file for an ibox
install
reboot
text
url --url=http://linuxsoft.cern.ch/centos/7/os/x86_64/
lang en_US.UTF-8
keyboard sg-latin1
# vagrant
rootpw --iscrypted $6$wh9o61rw$P.wXncXtXF/W.7wt1ui8x/7fj0P9Zy3Yy8UmbBUZFPECh4wkPF174qRpgEvuKrhAsaiP9L8wBR6jvS.rs1BXZ.
firewall --enabled --port=22:tcp
authconfig --enableshadow --passalgo=sha512 --disablefingerprint
timezone --utc Europe/Zurich
services --disabled fcoe,ip6tables,iptables,iscsi,iscsid,lldpad,netfs,nfslock,rpcbind,rpcgssd,rpcidmapd,udev-post,lvm2-monitor,postfix,avahi-daemon,hal,kudzu,autofs,readahead,kdump
# NOTE: we need the NM for vagrant deployments
# NetworkManager
bootloader --location=mbr
firstboot --disable

zerombr
%include /tmp/kspre.cfg
volgroup vg-ibox pv.01
logvol  /tmp  --vgname=vg-ibox --size=1024      --name=tmp  --fstype=ext4
logvol  swap  --vgname=vg-ibox --size=1024      --name=swap --fstype=swap
logvol  /     --vgname=vg-ibox --size=1 --grow  --name=root --fstype=ext4

network --onboot yes --device eth0 --bootproto dhcp

repo --name=centos.7.x86_64.os --baseurl=http://linuxsoft.cern.ch/centos/7/os/x86_64/
repo --name=centos.7.x86_64.updates --baseurl=http://linuxsoft.cern.ch/centos/7/updates/x86_64/
repo --name=centos.7.x86_64.epel --baseurl=http://mirror.switch.ch/ftp/mirror/epel/7/x86_64/
repo --name=centos.7.x86_64.extras --baseurl=http://linuxsoft.cern.ch/centos/7/extras/x86_64/
repo --name=puppet.x86_64.products --baseurl=http://yum.puppetlabs.com/el/7/products/x86_64/
repo --name=puppet.x86_64.deps --baseurl=http://yum.puppetlabs.com/el/7/dependencies/x86_64/
repo --name=centos.7.x86_64.glei --baseurl=http://yum.glei.ch/el7/x86_64/

%packages
irqbalance
man-pages
mlocate
openssh-clients
openssh-server
tcp_wrappers
vim-enhanced
wget
which
virt-what
policycoreutils-python
sudo
acpid
iptables-services
-bluez-utils
-firstboot-tui
-kudzu
-system-config-network-tui
-cpuspeed
-pcsc-lite
-ccid
-coolkey
-ifd-egate
-readahead
-oddjob
-NetworkManager
-dhcdbd
-aspell
-Deployment_Guide-en-US
-desktop-file-utils
-htmlview
-pinfo
-redhat-menus
-dos2unix
-dosfstools
-mkbootdisk
-fbset
-pcmciautils
-system-config-securitylevel-tui
-wireless-tools
-rhpl
-wpa_supplicant

-microcode_ctl
-smartmontools

-redhat-lsb-core
-dracut-config-rescue

puppet

# packages that are used on all systems
# TODO: integrate when released
#centos-release-cr
epel-release
yum-plugin-priorities
deltarpm
rkhunter
tmux
screen
yum-cron
shorewall
bash-completion
haveged
munin-node
mc
denyhosts
cryptsetup
gpm
chrony

%end

%pre

disk=none
for i in vda xvda sda; do
  if [ -b /dev/$i ]; then
    disk=$i
  fi
done

if [ ! -b /dev/$disk ]; then
 exec < /dev/tty3 > /dev/tty3
 chvt 3
 echo "ERROR: Drive device does not exist at /dev/$disk!"
 sleep 5
 halt -f
fi


cat >/tmp/kspre.cfg <<CFG
clearpart --initlabel --all --drives=$disk
ignoredisk --only-use=$disk
part /boot --fstype ext4 --size=512 --ondrive=$disk
part pv.01 --size=1 --grow --ondrive=$disk
CFG

%end

%post
cat <<-EOF >/etc/puppet/puppet.conf
[main]
    logdir=/var/log/puppet
    vardir=/var/lib/puppet
    rundir=/var/run/puppet

    ssldir=\$vardir/ssl

    # Where 3rd party plugins and modules are installed
    libdir = \$vardir/lib

    factpath = \$libdir/facter

[agent]
    report=true
    pluginsync = true

    # different run-interval, default= 30min
    # e.g. run puppetd every 4 hours = 14400
    # runinterval = 14400

    logdest=/var/log/puppet/puppet.log

    configtimeout=600
EOF

%end
