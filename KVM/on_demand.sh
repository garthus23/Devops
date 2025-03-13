#!/bin/bash
# create a vm on demand

export VIRSH_DEFAULT_CONNECT_URI='qemu:///system'

# $1 is the os to install
# $2 is the vmname

if [[ $1 && $2 ]]
then
    if [[ $1 == "rocky" ]] || [[ $1 == "ubuntu" ]]
    then
        sed -i s/"IMAGE_NAME.*"/"IMAGE_NAME=$2"/g vars.sh
        cd $1
        echo "local-hostname: $2" > meta-data
        ./cloudinit.sh
    else
        echo './on_demand.sh $OS $VMNAME'
        exit 1
    fi
fi
