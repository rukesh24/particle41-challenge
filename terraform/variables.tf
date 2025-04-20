variable "location" {
  description = "The Azure region where resources will be created."
  type        = string
  default     = "centralindia" # Your chosen region
}

variable "resource_group_name_prefix" {
  description = "Prefix for the resource group name."
  type        = string
  default     = "particle41-challenge"
}

variable "acr_name_prefix" {
  description = "Prefix for the Azure Container Registry name (alphanumeric, globally unique)."
  type        = string
  default     = "acrrukesh2401a" # Your chosen unique prefix
}

variable "container_image_repo_tag" {
  description = "The Docker image name and tag (e.g., simple-time-service:v1.2)."
  type        = string
  default     = "simple-time-service:v1.2" # Base image name + tag to push to ACR
}

variable "container_name_prefix" {
  description = "Prefix for the container instance name."
  type        = string
  default     = "timeservice"
}

variable "container_cpu" {
  description = "Number of CPU cores for the container."
  type        = number
  default     = 1.0
}

variable "container_memory" {
  description = "Amount of memory (in GB) for the container."
  type        = number
  default     = 1.5
}

variable "container_port" {
  description = "Port the container listens on internally."
  type        = number
  default     = 5000
}
