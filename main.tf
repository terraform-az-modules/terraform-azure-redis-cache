##-----------------------------------------------------------------------------
# Standard Tagging Module – Applies standard tags to all resources for traceability
##-----------------------------------------------------------------------------
module "labels" {
  source          = "terraform-az-modules/labels/azure"
  version         = "1.0.0"
  name            = var.custom_name == null ? var.name : var.custom_name
  location        = var.location
  environment     = var.environment
  managedby       = var.managedby
  label_order     = var.label_order
  repository      = var.repository
  deployment_mode = var.deployment_mode
  extra_tags      = var.extra_tags
}

##-----------------------------------------------------------------------------
## Azure Redis Cache - Main Redis instance configuration
##-----------------------------------------------------------------------------
resource "azurerm_redis_cache" "main" {
  count                              = var.enable ? 1 : 0
  name                               = var.resource_position_prefix ? format("redis-%s", local.name) : format("%s-redis", local.name)
  location                           = var.location
  resource_group_name                = var.resource_group_name
  capacity                           = var.capacity
  family                             = var.family
  sku_name                           = var.sku_name
  non_ssl_port_enabled               = var.non_ssl_port_enabled
  minimum_tls_version                = var.minimum_tls_version
  access_keys_authentication_enabled = var.access_keys_authentication_enabled
  public_network_access_enabled      = var.public_network_access_enabled
  redis_version                      = var.redis_version
  replicas_per_master                = var.replicas_per_master
  replicas_per_primary               = var.replicas_per_primary
  tags                               = module.labels.tags
  dynamic "patch_schedule" {
    for_each = var.patch_schedule != null ? [var.patch_schedule] : []
    content {
      day_of_week    = var.patch_schedule.day_of_week
      start_hour_utc = var.patch_schedule.start_hour_utc
    }
  }
  redis_configuration {
    authentication_enabled                  = var.redis_config.authentication_enabled
    maxmemory_reserved                      = var.redis_config.maxmemory_reserved
    maxmemory_delta                         = var.redis_config.maxmemory_delta
    data_persistence_authentication_method  = var.redis_config.data_persistence_authentication_method
    maxfragmentationmemory_reserved         = var.redis_config.maxfragmentationmemory_reserved
    maxmemory_policy                        = var.redis_config.maxmemory_policy
    active_directory_authentication_enabled = var.redis_config.active_directory_authentication_enabled
    rdb_backup_enabled                      = var.redis_config.backup_enabled && var.sku_name == "Premium"
    rdb_backup_frequency                    = var.redis_config.backup_enabled && var.sku_name == "Premium" ? var.redis_config.rdb_backup_frequency : null
    aof_storage_connection_string_0         = var.redis_config.aof_backup_enabled ? var.redis_config.aof_storage_connection_string_0 : null
    aof_backup_enabled                      = var.redis_config.aof_backup_enabled
  }
}

##-----------------------------------------------------------------------------
## Redis Firewall Rule - Define IP rules to restrict inbound access
##-----------------------------------------------------------------------------
resource "azurerm_redis_firewall_rule" "main" {
  for_each            = var.enable && length(var.firewall_rules) > 0 ? { for idx, rule in var.firewall_rules : idx => rule } : {}
  name                = var.resource_position_prefix ? format("redis_fw_%s", replace(local.name, "-", "_")) : format("%s_redis_fw", replace(local.name, "-", "_"))
  redis_cache_name    = azurerm_redis_cache.main[0].name
  resource_group_name = var.resource_group_name
  start_ip            = each.value.start_ip
  end_ip              = each.value.end_ip
}

##-----------------------------------------------------------------------------
## Redis Linked Server - Setup active geo-replication arcoss Redis instances
##-----------------------------------------------------------------------------
resource "azurerm_redis_linked_server" "main" {
  count                       = var.enable && var.secondary_enabled ? 1 : 0
  target_redis_cache_name     = azurerm_redis_cache.main[0].name
  resource_group_name         = var.resource_group_name
  linked_redis_cache_id       = azurerm_redis_cache.secondary[0].id
  linked_redis_cache_location = var.secondary_location
  server_role                 = var.server_role
}

##----------------------------------------------------------------------------- 
## Redis Cache resource that manages the Azure Redis Cache Policy
##----------------------------------------------------------------------------- 
resource "azurerm_redis_cache_access_policy" "main" {
  count          = var.enable ? 1 : 0
  name           = var.resource_position_prefix ? format("arc-policy-%s", local.name) : format("%s-arc-policy", local.name)
  redis_cache_id = azurerm_redis_cache.main[count.index].id
  permissions    = var.permissions
}

#-----------------------------------------------------------------------------
## Private Endpoint - Deploy private network access to Redis Cache
##---------------------------------------------------------------------------
resource "azurerm_private_endpoint" "pep" {
  count               = var.enable && var.enable_private_endpoint ? 1 : 0
  name                = var.resource_position_prefix ? format("pe-arc-%s", local.name) : format("%s-pe-arc", local.name)
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id
  tags                = module.labels.tags
  private_dns_zone_group {
    name                 = var.resource_position_prefix ? format("dns-zone-group-arc-%s", local.name) : format("%s-dns-zone-group-arc", local.name)
    private_dns_zone_ids = [var.private_dns_zone_ids]
  }
  private_service_connection {
    name                           = var.resource_position_prefix ? format("psc-arc-%s", local.name) : format("%s-psc-arc", local.name)
    is_manual_connection           = false
    private_connection_resource_id = azurerm_redis_cache.main[0].id
    subresource_names              = ["rediscache"]
  }
}

##-----------------------------------------------------------------------------
## Azure Redis Cache - Secondary
##-----------------------------------------------------------------------------
resource "azurerm_redis_cache" "secondary" {
  count                              = var.enable && var.secondary_enabled ? 1 : 0
  name                               = var.secondary_resource_position_prefix ? format("geo-redis-%s", local.name) : format("%s-geo-redis", local.name)
  location                           = var.secondary_location
  resource_group_name                = var.secondary_resource_group_name
  capacity                           = var.secondary_capacity
  family                             = var.secondary_family
  sku_name                           = var.secondary_sku_name
  non_ssl_port_enabled               = var.secondary_non_ssl_port_enabled
  minimum_tls_version                = var.secondary_minimum_tls_version
  access_keys_authentication_enabled = var.secondary_access_keys_authentication_enabled
  public_network_access_enabled      = var.secondary_public_network_access_enabled
  redis_version                      = var.secondary_redis_version
  replicas_per_master                = var.secondary_replicas_per_master
  replicas_per_primary               = var.secondary_replicas_per_primary
  tags                               = module.labels.tags
  dynamic "patch_schedule" {
    for_each = var.secondary_patch_schedule != null ? [var.secondary_patch_schedule] : []
    content {
      day_of_week    = var.secondary_patch_schedule.day_of_week
      start_hour_utc = var.secondary_patch_schedule.start_hour_utc
    }
  }
  redis_configuration {
    authentication_enabled                  = var.secondary_redis_config.authentication_enabled
    maxmemory_reserved                      = var.secondary_redis_config.maxmemory_reserved
    maxmemory_delta                         = var.secondary_redis_config.maxmemory_delta
    data_persistence_authentication_method  = var.secondary_redis_config.data_persistence_authentication_method
    maxfragmentationmemory_reserved         = var.secondary_redis_config.maxfragmentationmemory_reserved
    maxmemory_policy                        = var.secondary_redis_config.maxmemory_policy
    active_directory_authentication_enabled = var.secondary_redis_config.active_directory_authentication_enabled
    rdb_backup_enabled                      = var.secondary_redis_config.backup_enabled && var.secondary_sku_name == "Premium" && !var.enable_geo_replication
    rdb_backup_frequency                    = var.secondary_redis_config.backup_enabled && var.secondary_sku_name == "Premium" && !var.enable_geo_replication ? var.secondary_redis_config.rdb_backup_frequency : null
    aof_storage_connection_string_0         = var.secondary_redis_config.aof_backup_enabled && !var.enable_geo_replication ? var.secondary_redis_config.aof_storage_connection_string_0 : null
    aof_backup_enabled                      = var.secondary_redis_config.aof_backup_enabled && !var.enable_geo_replication
  }
}

##-----------------------------------------------------------------------------
## Diagnostic Setting - Deploy monitoring and logging for Redis Cache
##-----------------------------------------------------------------------------
resource "azurerm_monitor_diagnostic_setting" "arc-diag" {
  count                      = var.enable && var.enable_diagnostic ? 1 : 0
  name                       = var.resource_position_prefix ? format("diag-log-arc-%s", local.name) : format("%s-diag-log-arc", local.name)
  target_resource_id         = azurerm_redis_cache.main[0].id
  storage_account_id         = var.storage_account_id
  log_analytics_workspace_id = var.log_analytics_workspace_id
  dynamic "enabled_log" {
    for_each = var.logs
    content {
      category_group = lookup(enabled_log.value, "category_group", null)
      category       = lookup(enabled_log.value, "category", null)
    }
  }
  dynamic "enabled_metric" {
    for_each = var.metric_enabled ? ["AllMetrics"] : []
    content {
      category = enabled_metric.value
    }
  }
}