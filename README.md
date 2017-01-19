# iBox - immerda's stemcell

This is a basic setup of an immerda box which can then be used to
setup things further.

## Requirements

1. [Packer](http://packer.io)

## Getting started

    git clone https://git.immerda.ch/ibox/ibox-stemcell
    cd ibox-stemcell

## Build a stemcell for a certain template & provider

    # build centos7 for virtualbox
    ./build.sh virtualbox
    # build centos7 for kvm
    ./build.sh qemu

## build all

    # be sure to not use ssh-agent
    ./build.sh all

This will create boxes in builds/{qemu,virtualbox} which can the be uploaded and published.

