output "manager_ips" {
  value = "${libvirt_domain.manager.*.network_interface.0.addresses.0}"
}

output "worker_ips" {
  value = "${libvirt_domain.worker.*.network_interface.0.addresses.0}"
}
