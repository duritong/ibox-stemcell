# kickstart file for an ibox
install
reboot
text
url --url=http://linuxsoft.cern.ch/centos/7/os/x86_64/
lang en_US.UTF-8
keyboard sg-latin1
# vagrant
rootpw --iscrypted $6$wh9o61rw$P.wXncXtXF/W.7wt1ui8x/7fj0P9Zy3Yy8UmbBUZFPECh4wkPF174qRpgEvuKrhAsaiP9L8wBR6jvS.rs1BXZ.
authconfig --enableshadow --passalgo=sha512 --disablefingerprint
timezone --utc Europe/Zurich
services --disabled=fcoe,ip6tables,iptables,iscsi,iscsid,lldpad,netfs,nfslock,rpcbind,rpcgssd,rpcidmapd,udev-post,lvm2-monitor,postfix,avahi-daemon,hal,kudzu,autofs,readahead,kdump,firewalld  --enabled=haveged,shorewall,denyhosts
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

cat <<-EOF > /etc/yum.repos.d/glei.repo
[glei]
name=CentOS-\$releasever - glei
baseurl=http://yum.glei.ch/el\$releasever/\$basearch/
enabled=1
gpgcheck=1
priority=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-glei
timeout=10
metadata_expire=300
EOF

cat <<-EOF > /etc/pki/rpm-gpg/RPM-GPG-KEY-glei
-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.4.11 (GNU/Linux)

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
4fYAn1/c3GMGEeJ9/s8sUqqJg52txjHo
=HfVl
-----END PGP PUBLIC KEY BLOCK-----
EOF

echo 'net     ipv4'                                     >> /etc/shorewall/zones
echo '$FW     all     ACCEPT'                           >> /etc/shorewall/policy
echo 'net all     DROP    info'                         >> /etc/shorewall/policy
echo 'all     all     REJECT  info'                     >> /etc/shorewall/policy
echo 'ACCEPT     net           $FW       tcp        22' >> /etc/shorewall/rules
sed -i 's/STARTUP_ENABLED=.*/STARTUP_ENABLED=Yes/'         /etc/shorewall/shorewall.conf
echo "net $(facter interfaces | awk -F, '{ print $1 }') routefilter,blacklist,tcpflags,logmartians,nosmurfs" >> /etc/shorewall/interfaces


%end
