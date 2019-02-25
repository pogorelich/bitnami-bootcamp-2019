#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /liblog.sh
. /mylib.sh

info Starting etcd...

if [[ -n "${ETCD_CONFIGURATION_FILE}" ]]; then
    ETCD_CONF_FILE_PATH="${CONFIGURATION_VOLUME_DIR}/${ETCD_CONFIGURATION_FILE}"
    if [[ -f "${ETCD_CONF_FILE_PATH}" ]]; then
        info Configuration file found at: ${ETCD_CONF_FILE_PATH}
        exec etcd --config-file ${ETCD_CONF_FILE_PATH}
    fi
fi
warn No configuration file found!
exec etcd
