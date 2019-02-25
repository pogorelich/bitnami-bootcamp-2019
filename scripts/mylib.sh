#!/bin/bash

CONFIGURATION_VOLUME_DIR="/configuration"
DEFAULT_ETCDCTL_ROOT_PASSWORD="toor"

am_i_root() 
{
    if [[ "$(id -u)" = "0" ]]; then
        true
    else
	    false
    fi
}

