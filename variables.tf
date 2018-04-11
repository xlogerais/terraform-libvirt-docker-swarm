/* Variables */

variable "prefix" {
  default = "tf_swarm"
}

variable "libvirt_pool" {
  default = "default"
}

variable "base_image_url" {
  description = "the url to download the base image from"
  default     = "https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img"
}

variable "managers" { default = 3 }
variable "workers"  { default = 3 }

