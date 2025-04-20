# Random string for unique Resource Group name
resource "random_string" "rg_suffix" {
  length  = 6
  special = false
  upper   = false
  numeric = false
}

# Resource Group definition
resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name_prefix}-rg-${random_string.rg_suffix.result}"
  location = var.location # Using centralindia from variables.tf
  tags = {
    environment = "devops-challenge"
    owner       = "rukesh1324" # Your owner tag
  }
}

# Random string for unique ACR name
resource "random_string" "acr_suffix" {
  length  = 6
  special = false
  upper   = false
  numeric = true # Allow numbers
}

# Azure Container Registry definition
resource "azurerm_container_registry" "acr" {
  name                = "${var.acr_name_prefix}${random_string.acr_suffix.result}" # Using acrrukesh2401a prefix
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = false # Not needed for Managed Identity auth
  tags                = azurerm_resource_group.rg.tags
}

# Random string for unique ACI name/DNS label
resource "random_string" "aci_suffix" {
  length  = 6
  special = false
  upper   = false
  numeric = false
}

# NOTE: User Assigned Identity resource block is removed

# Grant the ACI's *System* Managed Identity permission to pull from ACR
resource "azurerm_role_assignment" "identity_acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  # Use the ACI's system identity principal_id (available after ACI starts creating)
  principal_id         = azurerm_container_group.aci.identity[0].principal_id
}

# Container Group using System Assigned Managed Identity for ACR auth
resource "azurerm_container_group" "aci" {
  name                = "${var.container_name_prefix}-aci-${random_string.aci_suffix.result}" # Using timeservice prefix
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  restart_policy      = "Always"

  # Request a System Assigned Managed Identity
  identity {
    type = "SystemAssigned"
  }

  # NOTE: image_registry_credential block is removed

  # Public IP and DNS
  ip_address_type = "Public"
  dns_name_label  = "${var.container_name_prefix}-${random_string.aci_suffix.result}"

  # Container definition pulling from ACR
  container {
    name   = var.container_name_prefix
    # Construct image path using ACR login server and the image name/tag variable
    image  = "${azurerm_container_registry.acr.login_server}/${var.container_image_repo_tag}" # Using simple-time-service:v1.2 from variables.tf
    cpu    = var.container_cpu
    memory = var.container_memory
    ports {
      port     = var.container_port # Internal port (5000)
      protocol = "TCP"
    }
  }

  tags = azurerm_resource_group.rg.tags

  # NOTE: depends_on block related to role assignment is removed
}
