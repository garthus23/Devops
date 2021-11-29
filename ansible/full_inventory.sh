#!/bin/bash

cat << EOF > inventory
all:
  children:
    ubuntu:
      hosts:
        $(cat  /var/lib/misc/dnsmasq.leases | grep ubuntu | cut -d ' ' -f 3)
      vars:
        ansible_python_interpreter: /usr/bin/python3

  children:
    centos:
      hosts:
        $(cat  /var/lib/misc/dnsmasq.leases | grep centos | cut -d ' ' -f 3)

EOF



