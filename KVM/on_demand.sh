#!/bin/bash
# create a vm on demand

# $1 is the os to install
# $2 is the vmname

if [[ $1 && $2 ]]
then
	if [[ $1 == 'centos' ]]
	then
		sed -i s/"IMAGE_NAME.*"/"IMAGE_NAME=$2"/g vars.sh
		echo "local-hostname: $2" > meta-data
		./cloudinit_centos.sh
	fi
	if [[ $1 == 'ubuntu' ]]
	then
		sed -i s/"IMAGE_NAME.*"/"IMAGE_NAME=$2"/g vars.sh
		echo "local-hostname: $2" > meta-data
		./cloudinit_ubuntu.sh
	fi
else
	echo './on_demand.sh $OS $VMNAME'
fi
