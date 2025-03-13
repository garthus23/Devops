#!/bin/bash
#list all vm IPS
export VIRSH_DEFAULT_CONNECT_URI='qemu:///system'

for VM in $(virsh list | tail -n +3 | sed -e 's/^\ //g' | cut -d ' ' -f 1)
do
	
	echo "---- $(virsh domname $VM) ----"
	virsh domifaddr $VM
done
