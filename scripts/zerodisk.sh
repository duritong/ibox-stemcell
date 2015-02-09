#!/bin/bash
set -x
# Zero out the free space to save space in the final image:
mount | grep ext4 | cut -d' ' -f 3 | while read mp; do
  dd if=/dev/zero of=$mp/EMPTY bs=1M
  sync
  rm -f $mp/EMPTY
  sync
done
exit