##-----------------------------------------------------------------------------
## Azure Redis Cache 
##-----------------------------------------------------------------------------
output "id" {
  value       = try(azurerm_redis_cache.main[0].id, null)
  description = "The ID of the Redis Cache instance"
}

output "hostname" {
  value       = try(azurerm_redis_cache.main[0].hostname, null)
  description = "The hostname of the Redis Cache instance"
}

output "ssl_port" {
  value       = try(azurerm_redis_cache.main[0].ssl_port, null)
  description = "The SSL port of the Redis Cache instance"
}

output "port" {
  value       = try(azurerm_redis_cache.main[0].port, null)
  description = "The non-SSL port of the Redis Cache instance"
}

##-----------------------------------------------------------------------------
## Access Keys & Connection Strings
##-----------------------------------------------------------------------------
output "primary_access_key" {
  value       = try(azurerm_redis_cache.main[0].primary_access_key, null)
  description = "The primary access key for the Redis Cache instance"
  sensitive   = true
}

output "secondary_access_key" {
  value       = try(azurerm_redis_cache.main[0].secondary_access_key, null)
  description = "The secondary access key for the Redis Cache instance"
  sensitive   = true
}

output "primary_connection_string" {
  value       = try(azurerm_redis_cache.main[0].primary_connection_string, null)
  description = "The primary connection string of the Redis Cache instance"
  sensitive   = true
}

output "secondary_connection_string" {
  value       = try(azurerm_redis_cache.main[0].secondary_connection_string, null)
  description = "The secondary connection string of the Redis Cache instance"
  sensitive   = true
}

##-----------------------------------------------------------------------------
## Configuration 
##-----------------------------------------------------------------------------
output "redis_configuration" {
  value       = try(azurerm_redis_cache.main[0].redis_configuration, null)
  description = "Redis configuration block applied to the cache instance"
}

output "maxclients" {
  value       = try(azurerm_redis_cache.main[0].redis_configuration[0].maxclients, null)
  description = "Maximum number of connected clients allowed"
}

##-----------------------------------------------------------------------------
## Access Policy 
##-----------------------------------------------------------------------------
output "access_policy_id" {
  value       = try(azurerm_redis_cache_access_policy.main[0].id, null)
  description = "The ID of the Redis Cache Access Policy"
}

##-----------------------------------------------------------------------------
## Firewall Rule
##-----------------------------------------------------------------------------
output "firewall_rule_ids" {
  value       = try({ for k, v in azurerm_redis_firewall_rule.main : k => v.id }, {})
  description = "Map of Redis Firewall Rule IDs indexed by rule key"
}

##-----------------------------------------------------------------------------
## Linked Server 
##-----------------------------------------------------------------------------
output "linked_server_id" {
  value       = try(azurerm_redis_linked_server.main[0].id, null)
  description = "The ID of the Redis Linked Server"
}

output "linked_server_name" {
  value       = try(azurerm_redis_linked_server.main[0].name, null)
  description = "The name of the Redis Linked Server"
}

output "geo_replicated_primary_host_name" {
  value       = try(azurerm_redis_linked_server.main[0].geo_replicated_primary_host_name, null)
  description = "The geo-replicated primary hostname of the linked server"
}
