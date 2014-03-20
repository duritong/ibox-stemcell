iBox - immerda's stemcell
=========================

This is a basic setup of an immerda box which can then be used to
setup things further.

Use
---

    git clone https://git.immerda.ch/ibox/ibox-stemcell ibox
    cd ibox
    # be sure to not use ssh-agent
    unset SSH_AUTH_SOCK
    veewee kvm build ibox

