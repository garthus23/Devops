#!/bin/bash
# cloud image deploy ubuntu 20.04 on Qemu/KVM

# set var file 
if [[ -f ../vars.sh ]]
then
	. ../vars.sh
fi

# Verify Iso is in folder $IMAGE_FOLDER
if [[ $(ls $IMAGE_FOLDER/rhel* | wc -l) -ne 1 ]]
then
	echo "Redhat iso not in folder $IMAGE_FOLDER"
	exit 1
fi

#--graphics spice,listen=127.0.0.1 
virt-install --connect qemu:///system --virt-type kvm --name $IMAGE_NAME --ram 2048 --vcpus=2 --os-variant rhl8.0 --disk path=$DISK_FOLDER/$IMAGE_NAME.qcow2,size=50,format=qcow2 --location=$(ls $IMAGE_FOLDER/rhel*) --network network=$NET --noautoconsole --graphics none --initrd-inject ks.cfg --initrd-inject ks.cfg --extra-args "inst.ks=file:/ks.cfg console=tty0 console=ttyS0,115200n8" 

