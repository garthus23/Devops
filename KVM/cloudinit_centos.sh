#!/bin/bash
# cloud image deploy ubuntu 20.04 on Qemu/KVM

# set var file 
if [[ -f vars.sh ]]
then
	. vars.sh
fi

# retrieve cloud image from ubuntu website
if [[ ! -f "$IMAGE_FOLDER/CentOS-Stream-GenericCloud-9-20220113.0.x86_64.qcow2" ]]
then
	wget https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-GenericCloud-9-20220113.0.x86_64.qcow2 -P $IMAGE_FOLDER
fi
# create disk image
qemu-img create -f qcow2 -F qcow2 -o backing_file=$IMAGE_FOLDER/CentOS-Stream-GenericCloud-9-20220113.0.x86_64.qcow2 $DISK_FOLDER/$IMAGE_NAME.qcow2

# resize the disk
qemu-img resize /home/kvm/disks/$IMAGE_NAME.qcow2 50G

# set a disk for user-data meta-data config
if [[ $IMAGE_FOLDER/cidata.iso ]]
then
	rm -f $IMAGE_FOLDER/cidata.iso
fi
genisoimage  -output $IMAGE_FOLDER/cidata.iso -V cidata -r -J user-data meta-data

# launch install
virt-install --connect qemu:///system --virt-type kvm --name $IMAGE_NAME --ram 2048 --vcpus=2 --os-type linux --os-variant centos-stream9 --import --disk path=$DISK_FOLDER/$IMAGE_NAME.qcow2,format=qcow2 --disk path=$IMAGE_FOLDER/cidata.iso,device=cdrom --network network=$NET --graphics none --noautoconsole
