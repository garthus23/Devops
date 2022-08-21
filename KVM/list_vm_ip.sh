#!/bin/bash
#list all vm IPS

for VM in $(virsh list | tail -n +3 | sed -e 's/^\ //g' | cut -d ' ' -f 1)
do
	
	echo "---- $(virsh domname $VM) ----"
	virsh guestinfo $VM | grep "172.16.0" 2>/dev/null
done
