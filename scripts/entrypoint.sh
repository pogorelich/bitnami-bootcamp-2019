#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /liblog.sh
. /mylib.sh

if am_i_root; then
    warn Root container is NOT recommended!
fi

if [[ "$*" = "/run.sh" ]]; then
    info "* Starting etcd setup..."
    /setup.sh
    info "* etcd setup finished!"
fi

exec "$@"