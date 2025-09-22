##-----------------------------------------------------------------------------
## Naming convention
##-----------------------------------------------------------------------------
variable "custom_name" {
  type        = string
  default     = null
  description = "Override default naming convention"
}

variable "resource_position_prefix" {
  type        = bool
  default     = true
  description = <<EOT
Controls the placement of the resource type keyword (e.g., "vnet", "ddospp") in the resource name.

- If true, the keyword is prepended: "vnet-core-dev".
- If false, the keyword is appended: "core-dev-vnet".

This helps maintain naming consistency based on organizational preferences.
EOT
}

##-----------------------------------------------------------------------------
## Labels
##-----------------------------------------------------------------------------
variable "name" {
  type        = string
  default     = "core"
  description = "Name  (e.g. `app` or `cluster`)."
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "managedby" {
  type        = string
  default     = "terraform-az-modules"
  description = "ManagedBy, eg 'terraform-az-modules'."
}

variable "extra_tags" {
  type        = map(string)
  default     = null
  description = "Variable to pass extra tags."
}

variable "repository" {
  type        = string
  default     = "https://github.com/terraform-az-modules/terraform-azure-redis-cache"
  description = "Terraform current module repo"

  validation {
    # regex(...) fails if it cannot find a match
    condition     = can(regex("^https://", var.repository))
    error_message = "The module-repo value must be a valid Git repo link."
  }
}

variable "location" {
  type        = string
  default     = "centralus"
  description = "The location/region where the virtual network is created. Changing this forces a new resource to be created."
}

variable "deployment_mode" {
  type        = string
  default     = "terraform"
  description = "Specifies how the infrastructure/resource is deployed"
}

variable "label_order" {
  type        = list(any)
  default     = ["name", "environment", "location"]
  description = "The order of labels used to construct resource names or tags. If not specified, defaults to ['name', 'environment', 'location']."
}

##-----------------------------------------------------------------------------
## Global Variables
##-----------------------------------------------------------------------------
variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the Redis Cache."
}

variable "enable" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources."
}

variable "redis_config" {
  type = object({
    authentication_enabled                  = bool
    maxmemory_reserved                      = number
    maxmemory_delta                         = number
    data_persistence_authentication_method  = string
    maxfragmentationmemory_reserved         = number
    maxmemory_policy                        = string
    active_directory_authentication_enabled = bool
    backup_enabled                          = bool
    rdb_backup_frequency                    = number
    aof_backup_enabled                      = bool
    aof_storage_connection_string_0         = string
  })
  default = {
    authentication_enabled                  = true
    maxmemory_reserved                      = 50
    maxmemory_delta                         = 50
    data_persistence_authentication_method  = "SAS"
    maxfragmentationmemory_reserved         = 50
    maxmemory_policy                        = "allkeys-lru"
    active_directory_authentication_enabled = false
    backup_enabled                          = false
    rdb_backup_frequency                    = 60
    aof_backup_enabled                      = false
    aof_storage_connection_string_0         = null
  }
  description = "Redis configuration settings"
}

variable "capacity" {
  type        = number
  default     = 1
  description = "Redis cache size"
}

variable "family" {
  type        = string
  default     = "C"
  description = "SKU family - C for Basic/Standard, P for Premium"
}

variable "sku_name" {
  type        = string
  default     = "Standard"
  description = "Redis SKU - Basic, Standard, or Premium"
}

variable "non_ssl_port_enabled" {
  type        = bool
  default     = false
  description = "Enable non-SSL port 6379"
}

variable "minimum_tls_version" {
  type        = string
  default     = "1.2"
  description = "Minimum TLS version"
}

variable "access_keys_authentication_enabled" {
  type        = bool
  default     = true
  description = "Enable access key authentication"
}

variable "public_network_access_enabled" {
  type        = bool
  default     = false
  description = "Allow public network access"
}

variable "redis_version" {
  type        = string
  default     = "6"
  description = "Redis version"
}

variable "replicas_per_master" {
  type        = number
  default     = 1
  description = "Number of replicas per master"
}

variable "replicas_per_primary" {
  type        = number
  default     = 1
  description = "Number of replicas per primary"
}


variable "patch_schedule" {
  type = object({
    day_of_week    = string
    start_hour_utc = number
  })
  default     = null
  description = "Redis maintenance schedule"
}

variable "firewall_rules" {
  type = map(object({
    start_ip = string
    end_ip   = string
  }))
  default = {
    access_to_azure = {
      start_ip = "10.0.3.0"
      end_ip   = "10.0.3.255"
    }
  }
  description = "Firewall IP address ranges"
}

variable "server_role" {
  type        = string
  default     = "Secondary"
  description = "Role of the linked server - Primary or Secondary"
}

variable "access_policy_name" {
  type        = string
  default     = "Data Contributor"
  description = "Name of the access policy to assign"
}

variable "user_object_id" {
  type        = string
  default     = null
  description = "Object ID of the user or service principal"
}

variable "object_id_alias" {
  type        = string
  default     = "ServicePrincipal"
  description = "Alias for the object ID"
}

variable "permissions" {
  type        = string
  default     = "+@read +@connection"
  description = "Permissions for the Redis cache access policy"
}

variable "secondary_enabled" {
  type        = bool
  default     = false
  description = "Enable secondary Redis cache"
}

variable "secondary_resource_position_prefix" {
  type        = bool
  default     = true
  description = "Position prefix for secondary Redis cache name"
}

variable "secondary_location" {
  type        = string
  default     = "eastus"
  description = "Location for secondary Redis cache"
}

variable "secondary_resource_group_name" {
  type        = string
  default     = null
  description = "Resource group name for secondary Redis cache"
}

variable "secondary_capacity" {
  type        = number
  default     = 1
  description = "Capacity for secondary Redis cache"
}

variable "secondary_family" {
  type        = string
  default     = "P"
  description = "SKU family for secondary Redis cache"
}

variable "secondary_sku_name" {
  type        = string
  default     = "Premium"
  description = "SKU name for secondary Redis cache"
}

variable "secondary_non_ssl_port_enabled" {
  type        = bool
  default     = false
  description = "Enable non-SSL port for secondary Redis cache"
}

variable "secondary_minimum_tls_version" {
  type        = string
  default     = "1.2"
  description = "Minimum TLS version for secondary Redis cache"
}

variable "secondary_access_keys_authentication_enabled" {
  type        = bool
  default     = true
  description = "Enable access key authentication for secondary Redis cache"
}

variable "secondary_public_network_access_enabled" {
  type        = bool
  default     = false
  description = "Enable public network access for secondary Redis cache"
}

variable "secondary_redis_version" {
  type        = string
  default     = "6"
  description = "Redis version for secondary cache"
}

variable "secondary_replicas_per_master" {
  type        = number
  default     = 1
  description = "Number of replicas per master for secondary Redis cache"
}

variable "secondary_replicas_per_primary" {
  type        = number
  default     = 1
  description = "Number of replicas per primary for secondary Redis cache"
}

variable "secondary_patch_schedule" {
  type = object({
    day_of_week    = string
    start_hour_utc = number
  })
  default     = null
  description = "Patch schedule for secondary Redis cache"
}

variable "secondary_redis_config" {
  type = object({
    authentication_enabled                  = bool
    maxmemory_reserved                      = number
    maxmemory_delta                         = number
    data_persistence_authentication_method  = string
    maxfragmentationmemory_reserved         = number
    maxmemory_policy                        = string
    active_directory_authentication_enabled = bool
    backup_enabled                          = bool
    rdb_backup_frequency                    = number
    aof_backup_enabled                      = bool
    aof_storage_connection_string_0         = string
  })
  default = {
    authentication_enabled                  = true
    maxmemory_reserved                      = 50
    maxmemory_delta                         = 50
    data_persistence_authentication_method  = "SAS"
    maxfragmentationmemory_reserved         = 50
    maxmemory_policy                        = "allkeys-lru"
    active_directory_authentication_enabled = false
    backup_enabled                          = false
    rdb_backup_frequency                    = 60
    aof_backup_enabled                      = false
    aof_storage_connection_string_0         = null
  }
  description = "Redis configuration settings for secondary cache"
}

variable "enable_geo_replication" {
  type        = bool
  default     = false
  description = "Enable geo-replication between primary and secondary Redis caches"
}
