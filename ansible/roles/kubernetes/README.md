Role Name
=========

Installation d'un cluster kubernetes on VM from scratch (only the package ansible installed and configured with my provisionning tool)

Requirements
------------

Tested on : Rocky 9 (generic cloud image) , ubuntu 20 (generic cloud image)

Example Playbook
----------------


```
- hosts: all
  become: yes
  roles:
    - kubernetes
```

Inventory
----------------

[masternode]


[workers]


Author Information
------------------

garthus@adminux.fr
gr.arthus@gmail.com
