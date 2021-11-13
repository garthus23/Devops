#!/bin/bash
# cloud init centos 8

if [[ $(qm list | grep -c centos8-templ) == 1 ]]
then
	echo "template exist"
else
	wget "https://cloud.centos.org/centos/8/x86_64/images/CentOS-8-GenericCloud-8.4.2105-20210603.0.x86_64.qcow2"

	# Create a VM
	qm create 9001 --name centos8-templ --memory 2048 --net0 virtio,bridge=vmbr0

	# Import the disk in qcow2 format (as unused disk) 
	qm importdisk 9001 "CentOS-8-GenericCloud-8.4.2105-20210603.0.x86_64.qcow2" local -format qcow2

	# Attach the disk to the vm using VirtIO SCSI
	qm set 9001 --scsihw virtio-scsi-pci --scsi0 /var/lib/vz/images/9001/vm-9001-disk-0.qcow2

	# Important settings
	qm set 9001 --ide2 local:cloudinit --boot c --bootdisk scsi0 --serial0 socket --vga serial0

	# The initial disk is only 2GB, thus we make it larger
	qm resize 9001 scsi0 +100G

	# Using a  dhcp server on vmbr1 or use static IP
	qm set 9001 --ipconfig0 ip=dhcp
	#qm set 9001 --ipconfig0 ip=10.10.10.222/24,gw=10.10.10.1

	# user authentication for 'ubuntu' user (optional password)
	#qm set 9001 --sshkey ~/.ssh/id_rsa.pub
	qm set 9001 --cipassword AweSomePassword

	# check the cloud-init config
	qm cloudinit dump 9001 user

	# create tempalte and a linked clone
	qm template 9001
	rm -v "CentOS-8-GenericCloud-8.4.2105-20210603.0.x86_64.qcow2"

fi


if [[ $(qm list | grep -Eo "^ +[0-9]{3,4}" | sed "s/\ //g" | grep -c 9001) == 0 ]]
then
	echo "No template Created"
	exit
else
	for ((VMID=100;;VMID++))
	do
		if (( $(qm list | grep -Eo "^ +[0-9]{3}" | sed "s/\ //g" | grep -c $VMID) == 0 ))
		then
			qm clone 9001 $VMID --name centos-8-$VMID
			qm start $VMID
			echo "VM $VMID Created"
			exit
		fi
	done
fi

