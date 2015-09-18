#!/bin/bash

if [ "$1" = 'all' ]; then
  providers="qemu virtualbox"
else
  providers=$1
fi
if [ -z $providers ]; then
  echo "Usage: $0 [all|qemu|virtualbox]"
  exit 1
fi
templates="centos7"
which packer.io 2>&1 > /dev/null
if [ $? -gt 0 ]; then
  alias packer.io='packer'
fi

for provider in $providers; do
  if [ $provider = 'virtualbox' ]; then
    only=virtualbox-iso
  else
    only=$provider
  fi
  for template in $templates; do
    echo "Building ${template}-${provider}"
    packer.io build -only=${only} ${template}.json
    echo "(Re)packaging ${template}-${provider}"
    if [ $provider = 'qemu' ]; then
      scripts/qemu_to_box.sh ibox-${template}-x86_64-qemu/packer-ibox-${template}-x86_64-qemu.qcow2
    else
      # hack the version into the vagrant file
      scripts/vagrant_set_version.sh builds/$provider/ibox-${template}-x86_64-${provider}.box
    fi
  done
done
