#!/bin/bash

if [ ! -f $1 ]; then
  echo "USAGE: $0 builds/<provider>/some.box"
  exit 1
fi

currdir=$(pwd)
boxfile=$(basename $1)

cd $(dirname $1)
tmpdir=$(mktemp -d ibox.XXXXX.img)
cd $tmpdir
tar xf ../$boxfile
ruby -rjson -e "m=JSON.load(File.read('metadata.json'));m['version']=Time.now.strftime('1.%Y%m%d%H%m');File.write('metadata.json',JSON.dump(m))"
tar cf ../$boxfile *
cd ..
rm -rf $tmpdir
cd $currdir
