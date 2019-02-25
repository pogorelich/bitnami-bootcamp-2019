#!/bin/bash

# Load libraries
. /libfs.sh
. /mylib.sh

# Check directories for etcd
for dir in $DATA_DIR $MEMBER_DIR $CONFIGURATION_VOLUME_DIR; do
    ensure_dir_exists "$dir"
    chmod -R g+rwX $dir
done
