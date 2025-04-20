output "container_ipv4_address" {
  description = "The public IP address of the deployed container."
  value       = azurerm_container_group.aci.ip_address
}

output "container_fqdn" {
  description = "The Fully Qualified Domain Name of the deployed container."
  value       = azurerm_container_group.aci.fqdn
}

output "resource_group_name" {
  description = "The name of the created resource group."
  value       = azurerm_resource_group.rg.name
}

output "acr_name" {
  description = "The name of the Azure Container Registry."
  value       = azurerm_container_registry.acr.name
}

output "acr_login_server" {
  description = "The login server (hostname) for the ACR instance."
  value       = azurerm_container_registry.acr.login_server
}
