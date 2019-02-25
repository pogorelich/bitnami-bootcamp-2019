#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /liblog.sh
. /mylib.sh

# Enable authentication
if [[ "${DISABLE_AUTHENTICATION}" != "yes" ]]; then
    if [[ -n "${ETCDCTL_ROOT_PASSWORD}" ]]; then
        ETCDCTL_ROOT_PASSWORD=${DEFAULT_ETCDCTL_ROOT_PASSWORD}
    fi
    # First we start etcd so etcdctl commands work
    etcd > /dev/null 2>&1 &
    ETCD_PID=$!
    # We give it some time to initialize
    sleep 3
    # We proceed then enabling authentication
    etcdctl user add root:${ETCDCTL_ROOT_PASSWORD}
    if [[ $? -eq 0 ]]; then
        etcdctl auth enable
        if [[ $? -eq 0 ]]; then
            info Authentication enabled!
        else
            warn Could not enable authentication!
        fi
    else
        warn Could not enable authentication!
    fi
    kill $ETCD_PID
else
    warn Authentication is disabled!
fi