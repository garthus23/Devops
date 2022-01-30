#!/bin/bash
# Delete vm from KVM

virsh destroy $1 && virsh undefine $1 && virsh vol-delete --pool disks $1.qcow2
