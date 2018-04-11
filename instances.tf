/* Volumes */

# Base OS image to use to create a cluster of different nodes
resource "libvirt_volume" "base_image" {
  name   = "${var.prefix}_base_image.qcow2"
  source = "${var.base_image_url}"
}

resource "libvirt_volume" "manager" {
  pool           = "${var.libvirt_pool}"
  name           = "${var.prefix}_manager${count.index}.qcow2"
  base_volume_id = "${libvirt_volume.base_image.id}"
  count          = "${var.managers}"
}

resource "libvirt_volume" "worker" {
  pool           = "${var.libvirt_pool}"
  name           = "${var.prefix}_worker${count.index}.qcow2"
  base_volume_id = "${libvirt_volume.base_image.id}"
  count          = "${var.workers}"
}

/* Cloud Drives */

data "template_file" "user_data_manager" {
  template = "${file("${path.module}/templates/manager.user-data.tpl")}"

  vars = {
    sshuser = "${var.sshuser}"
    sshpubkey = "${var.sshpubkey}"
  }
}

data "template_file" "user_data_worker" {
  template = "${file("${path.module}/templates/worker.user-data.tpl")}"

  vars = {
    sshuser = "${var.sshuser}"
    sshpubkey = "${var.sshpubkey}"
  }
}

resource "libvirt_cloudinit" "manager" {
  pool               = "${var.libvirt_pool}"
  name               = "${var.prefix}_manager${count.index}.cloudinit.iso"
  local_hostname     = "${var.prefix}_manager${count.index}"
  ssh_authorized_key = "${var.sshpubkey}"
  user_data          = "${data.template_file.user_data_manager.rendered}"
  count              = "${var.managers}"
}

resource "libvirt_cloudinit" "worker" {
  pool               = "${var.libvirt_pool}"
  name               = "${var.prefix}_worker${count.index}.cloudinit.iso"
  local_hostname     = "${var.prefix}_worker${count.index}"
  ssh_authorized_key = "${var.sshpubkey}"
  user_data          = "${data.template_file.user_data_worker.rendered}"
  count              = "${var.workers}"
}

/* Instances */

resource "libvirt_domain" "manager" {

  name   = "${var.prefix}_manager${count.index}"
  vcpu   = 4
  memory = "4096"

  disk {
    volume_id = "${element(libvirt_volume.manager.*.id, count.index)}"
  }

  network_interface {
    network_name = "${var.prefix}_network"
  }

  console {
    type = "pty"

    target_port = "0"
  }

  cloudinit = "${element(libvirt_cloudinit.manager.*.id, count.index)}"

  count = "${var.managers}"

}

resource "libvirt_domain" "worker" {

  name   = "${var.prefix}_worker${count.index}"
  vcpu   = 4
  memory = "4096"

  disk {
    volume_id = "${element(libvirt_volume.worker.*.id, count.index)}"
  }

  network_interface {
    network_name = "${var.prefix}_network"
  }

  console {
    type = "pty"

    target_port = "0"
  }

  cloudinit = "${element(libvirt_cloudinit.worker.*.id, count.index)}"

  count = "${var.workers}"

}
