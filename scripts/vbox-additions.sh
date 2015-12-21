#!/bin/bash

[ "${SKIP_ADDITIONS}" -eq "1" ] && exit 0

yum install -y binutils qt gcc make patch libgomp glibc-headers glibc-devel kernel-headers kernel-devel dkms bzip2

# Mount the disk image
if [ -f /root/VBoxGuestAdditions*.iso ]; then
  mount -t iso9660 -o loop /root/VBoxGuestAdditions*.iso /mnt

  # Install the drivers
  export KERN_DIR=/usr/src/kernels/`uname -r`
  export MAKE='/usr/bin/gmake -i'
  /mnt/VBoxLinuxAdditions.run || (echo "Failure while installing VBOX Additions" && exit 1)
  umount /mnt
  rm -f /root/VBoxGuestAdditions*.iso
else
  echo "No vbox additions found!"
  exit 1
fi
