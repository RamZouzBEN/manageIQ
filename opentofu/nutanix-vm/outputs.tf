output "vm_name" {
  description = "Nom de la VM créée"
  value       = nutanix_virtual_machine.vm.name
}

output "vm_uuid" {
  description = "Identifiant de la VM dans Prism Central"
  value       = nutanix_virtual_machine.vm.id
}

output "vm_ip" {
  description = "Adresse IP de la VM, si elle est déjà connue"
  value       = try(nutanix_virtual_machine.vm.nic_list_status[0].ip_endpoint_list[0].ip, null)
}
