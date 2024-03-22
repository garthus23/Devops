# How to use 

on KVM provider
```
terraform init
terraform apply
```

# Troubleshooting 

permission error on pool path : 

some changes are needed in Apparmor/Selinux...

Apparmor changes:

cat /etc/apparmor.d/libvirt/TEMPLATE.qemu
```
#include <tunables/global>

profile LIBVIRT_TEMPLATE flags=(attach_disconnected) {
  #include <abstractions/libvirt-qemu>
  $PATHTODISK**.qcow2 rwk,
  $PATHTODISK**.raw rwk,
  $PATHTODISK**.img rwk,
  $PATHTOIMG**.qcow2 rwk,
  $PATHTOIMG**.raw rwk,
  $PATHTOIMG**.img rwk,
}
```
!! replace the var with a real path you moron
