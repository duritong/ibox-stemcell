# iBox - immerda's stemcell

This is a basic setup of an immerda box which can then be used to
setup things further.

## Requirements

1. Vagrant with KVM
1. bundle from a recent ruby

## Installation

    git clone https://git.immerda.ch/ibox/ibox-stemcell
    cd ibox-stemcell
    bundle install

## Build the stemcell

    # be sure to not use ssh-agent
    unset SSH_AUTH_SOCK
    veewee kvm build ibox-stemcell
    # if it suceeded you can connect to it using the root password: vagrant
    # shutdown the vm afterwards to export it
    veewee kvm export 'ibox-stemcell'

The exported image can then be shared.
