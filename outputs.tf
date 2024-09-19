output "instances_private_ip" {
  description = "Google Compute Engine Instances Private IPs"
  value       = google_compute_instance.vm.*.network_interface.0.network_ip
}

output "instances_public_ip" {
  description = "Google Compute Engine Instances Public IPs"
  value       = google_compute_instance.vm.*.network_interface.0.access_config.0.nat_ip
}

output "public_ssh_key" {
  description = "Public SSH key if a new key pair is created, otherwise null"
  value       = var.create_ssh_key_pair ? tls_private_key.ssh_private_key[0].public_key_openssh : null
}

output "instance_ips" {
  description = "List of instances' public and private IPs"
  value = [
    for i in google_compute_instance.vm.*.network_interface.0 :
    {
      public_ip  = i.access_config.0.nat_ip
      private_ip = i.network_ip
    }
  ]
}

output "devstack_url" {
  description = "DevStack URL"
  value       = "https://${google_compute_instance.vm[0].network_interface.0.access_config.0.nat_ip}"
}
