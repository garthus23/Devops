terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
  # Configuration options
}

resource "libvirt_volume" "ubuntu22" {
  name   = "ubuntu22.qcow2"
  pool   = "isos"
  source = var.imgsrc
  format = "qcow2"
}

resource "libvirt_volume" "node_disk" {
  count          = var.vmnumber
  name           = "node-${count.index}.qcow2"
  pool           = "Disks"
  base_volume_id = libvirt_volume.ubuntu22.id
}


resource "libvirt_network" "kube_network" {
  name      = "kube"
  mode      = "nat"
  domain    = "k8s.local"
  addresses = [var.netrange[0].subnet]
  dhcp { enabled = true }
  dns { enabled = true }
}

resource "libvirt_domain" "node11" {
  count = var.vmnumber
  name  = "node_${count.index}"
  #  machine = "pc-q35-5.2"
  memory = "2048"
  vcpu   = 2
  disk {
    volume_id = libvirt_volume.node_disk[count.index].id
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  network_interface {
    network_name = "kube"
    hostname     = "node_${count.index}"
    addresses    = ["${var.netrange[0].ip}${count.index}"]
    #mac            = "52:54:00:c6:38:87"
    wait_for_lease = true
  }
  filesystem {
    source   = "/data"
    target   = "data"
    readonly = true
  }

  cloudinit = libvirt_cloudinit_disk.commoninit.id
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name      = "commoninit.iso"
  user_data = data.template_file.user_data.rendered
  pool      = "isos"
}

data "template_file" "user_data" {
  template = file("${path.module}/cloud_init.cfg")
}
