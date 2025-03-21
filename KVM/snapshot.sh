#!/bin/bash

set -e

if [[ $1 == 'list' ]]
then
	if ! [[ $2 ]] 
	then
		echo './snapshot.sh list $domain'
	else
		virsh snapshot-list $2
	fi
fi


if [[ $1 == 'create' ]]
then
	if ! [[ $2 ]] || ! [[ $3 ]]
	then
		echo './snapshot.sh create $domain $snapshotname'
	else
		virsh snapshot-create-as $2 --name $3 --disk-only
		virsh snapshot-list $2
	fi	
fi


if [[ $1 == 'revert' ]]
then
	if ! [[ $2 ]] || ! [[ $3 ]]
	then
		echo './snapshot.sh revert $domain $snapshotname'
	else
		diskdev=$(virsh domblklist $2 | grep "$2.$3" | grep -Eo '[aA-zZ].+ ')
		dpath=$(virsh domblklist gentoo | grep gentoo.toto | grep -Eo '\/.*\/')
		virsh destroy $2
		virt-xml $2 --remove-device --disk target=$diskdev 
		virt-xml $2 --add-device --disk ${dpath}$2.qcow2,target=$diskdev 
		virsh snapshot-delete --metadata $2 $3
		echo "delete the file $dpath$2.$3"
		rm "$dpath$2.$3"
		virsh start $2
	fi
fi
