/* Réseaux */

resource "libvirt_network" "network" {
  name   = "${var.prefix}_network"
  bridge = "${var.prefix}"
  mode   = "nat"

  dhcp = {
    enabled = true
  }

  addresses = ["10.0.120.0/24"]
  domain    = "${var.prefix}"
}
