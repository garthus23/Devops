#!/bin/bash
# create a vm on demand

# $1 is the os to install
# $2 is the vmname

if [[ $1 && $2 ]]
then
    if [[ $1 == 'centos' ]] || [[ $1 == 'ubuntu' ]]
    then
        cd $1
        sed -i s/"IMAGE_NAME.*"/"IMAGE_NAME=$2"/g vars.sh
        echo "local-hostname: $2" > meta-data
        ./cloudinit.sh
    else
        echo './on_demand.sh $OS $VMNAME'
        exit 1
    fi
fi
