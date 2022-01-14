#!/bin/bash
#list all vm IPS

for VM in $(virsh list | tail -n +3 | sed -e 's/^\ //g' | cut -d ' ' -f 4)
do
	
	echo "---- $VM ----"
	virsh domifaddr $VM --source arp | tail +3
done
