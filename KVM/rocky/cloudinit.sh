#!/bin/bash
# cloud image deploy Rocky Linux 9 on Qemu/KVM

# set var file 
if [[ -f ../vars.sh ]]
then
	. ../vars.sh
fi

DLNAME='https://dl.rockylinux.org/pub/rocky/9/images/x86_64/Rocky-9-GenericCloud-Base.latest.x86_64.qcow2'

# retrieve cloud image from ubuntu website
if [[ ! -f "$IMAGE_FOLDER/$(basename $DLNAME)" ]]
then
	wget $DLNAME -P $IMAGE_FOLDER
fi

# check Disk Folder Exist
if [[ ! -d $DISK_FOLDER ]]
then
	mkdir -p $DISK_FOLDER
fi

# create disk image
qemu-img create -f qcow2 -F qcow2 -o size=50G -o backing_file=$IMAGE_FOLDER/$(basename $DLNAME) $DISK_FOLDER/$IMAGE_NAME.qcow2

# set a disk for user-data meta-data config
if [[ $IMAGE_FOLDER/cidata.iso ]]
then
	rm -f $IMAGE_FOLDER/cidata.iso
fi
genisoimage  -output $IMAGE_FOLDER/cidata.iso -V cidata -r -J user-data meta-data

# launch install 
#--graphics spice,listen=127.0.0.1 
virt-install --connect qemu:///system --virt-type kvm --name $IMAGE_NAME --ram 2048 --vcpus=2 --os-variant rhl9 --import --disk path=$DISK_FOLDER/$IMAGE_NAME.qcow2,format=qcow2 --disk path=$IMAGE_FOLDER/cidata.iso,device=cdrom --network network=$NET --noautoconsole --graphics none

# detach cdrom on next boot
virsh change-media $IMAGE_NAME $IMAGE_FOLDER/cidata.iso --config --eject
