#!/bin/bash
# cloud init ubuntu server 20.04

if [[ $(qm list | grep -c ubuntu2004-templ) == 1 ]]
then
	echo "template exist"
else
	wget https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img

	# Create a VM
	qm create 9000 --name ubuntu2004-templ --memory 2048 --net0 virtio,bridge=vmbr0

	# Import the disk in qcow2 format (as unused disk) 
	qm importdisk 9000 focal-server-cloudimg-amd64.img local -format qcow2

	# Attach the disk to the vm using VirtIO SCSI
	qm set 9000 --scsihw virtio-scsi-pci --scsi0 /var/lib/vz/images/9000/vm-9000-disk-0.qcow2

	# Important settings
	qm set 9000 --ide2 local:cloudinit --boot c --bootdisk scsi0 --serial0 socket --vga serial0

	# The initial disk is only 2GB, thus we make it larger
	qm resize 9000 scsi0 +100G

	# Using a  dhcp server on vmbr1 or use static IP
	qm set 9000 --ipconfig0 ip=dhcp
	#qm set 9000 --ipconfig0 ip=10.10.10.222/24,gw=10.10.10.1

	# user authentication for 'ubuntu' user (optional password)
	#qm set 9000 --sshkey ~/.ssh/id_rsa.pub
	qm set 9000 --cipassword AweSomePassword

	# check the cloud-init config
	qm cloudinit dump 9000 user

	# create tempalte and a linked clone
	qm template 9000
	rm -v focal-server-cloudimg-amd64.img

fi

if [[ $(qm list | grep -Eo "^ +[0-9]{3,4}" | sed "s/\ //g" | grep -c 9000) == 0 ]]
then
	echo "No template Created"
	exit
	
else
	for ((VMID=100;;VMID++))
	do
		if (( $(qm list | grep -Eo "^ +[0-9]{3}" | sed "s/\ //g" | grep -c $VMID) == 0 ))
		then
			qm clone 9000 $VMID --name ubuntu-2004-$VMID
			qm start $VMID
			echo "VM $VMID Created"
			exit
		fi
	done
fi
