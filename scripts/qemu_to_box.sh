#!/bin/bash


if [ -z $1 ] || [ ! -f $1 ]; then
  echo "USAGE: ${0} image.qcow2"
  exit 1
fi

[ -d builds/qemu ] || mkdir -p builds/qemu
tmpdir=$(mktemp -d packer_cache/ibox.XXXXX.img)
name=$(basename $1 .qcow2 | sed 's/packer-//')
qemu-img convert -c -O qcow2 $1 $tmpdir/box.img
pushd $tmpdir > /dev/null
echo 'Vagrant.require_plugin "vagrant-libvirt"' > Vagrantfile
cat > metadata.json << END
{
  "provider"      : "libvirt",
  "format"        : "qcow2",
  "virtual_size"  : 8,
  "version"       : "1.$(date +%Y%m%d%H%M)"
}
END
tar czf ../../builds/qemu/${name}.box ./metadata.json  ./Vagrantfile box.img
popd > /dev/null
rm -rf $tmpdir
rm -rf $(dirname $1)
