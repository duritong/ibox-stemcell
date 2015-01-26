# iBox - immerda's stemcell

This is a basic setup of an immerda box which can then be used to
setup things further.

## Requirements

1. [Packer](http://packer.io)

## Getting started

    git clone https://git.immerda.ch/ibox/ibox-stemcell
    cd ibox-stemcell

## build all

    # be sure to not use ssh-agent
    unset SSH_AUTH_SOCK
    ./build_all.sh

This will create boxes in builds/{qemu,virtualbox} which can the be uploaded and published.

## Build a stemcell for a certain template & provider

    # be sure to not use ssh-agent
    unset SSH_AUTH_SOCK
    # build centos7 for virtualbox
    packer build -only=virtualbox-iso centos7.json
    # build centos7 for kvm
    packer build -only=qemu centos7.json
    # Attention: the post-processors for vagrant currently do not set a version
    # you can set it using
    scripts/vagrant_set_version.sh builds/virtualbox/
    # packer currently misses a post-processor for a qemu vagrant box
    # so we have a little helper script for that
    scripts/qemu_to_box.sh ibox-centos7-x86_64-qemu/packer-ibox-centos7-x86_64-qemu.qcow2

