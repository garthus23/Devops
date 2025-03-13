#!/bin/bash
# cloud image deploy ubuntu 20.04 on Qemu/KVM

# set var file 
if [[ -f ../vars.sh ]]
then
	. ../vars.sh
fi

DLNAME='https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img'

# retrieve cloud image from ubuntu website
if [[ ! -f "$IMAGE_FOLDER/$(basename $DLNAME)" ]]
then
	wget $DLNAME -P $IMAGE_FOLDER
fi
# create disk image
qemu-img create -f qcow2 -F qcow2 -o size=50G -o backing_file=$IMAGE_FOLDER/$(basename $DLNAME) $DISK_FOLDER/$IMAGE_NAME.qcow2

# resize the disk
#qemu-img resize /home/kvm/disks/$IMAGE_NAME.qcow2 50G
#qemu-img info /home/kvm/disks/ubuntu2004-1.qcow2

# set a disk for user-data meta-data config
if [[ $IMAGE_FOLDER/cidata.iso ]]
then
	rm -f $IMAGE_FOLDER/cidata.iso
fi
#genisoimage  -output $IMAGE_FOLDER/cidata.iso -V cidata -r -J user-data meta-data
xorriso -as mkisofs  -output $IMAGE_FOLDER/cidata.iso -V cidata -r -J user-data meta-data

# launch install
#--graphics spice,listen=127.0.0.1 
virt-install --connect qemu:///system --virt-type kvm --name $IMAGE_NAME --ram 2048 --vcpus=2 --os-variant ubuntu20.04 --import --disk path=$DISK_FOLDER/$IMAGE_NAME.qcow2,format=qcow2 --disk path=$IMAGE_FOLDER/cidata.iso,device=cdrom --network network=$NET --noautoconsole --graphics none


# detach cdrom on next boot
virsh change-media $IMAGE_NAME $IMAGE_FOLDER/cidata.iso --config --eject
