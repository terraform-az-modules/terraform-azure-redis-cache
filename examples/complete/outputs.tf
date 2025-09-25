output "id" {
  value       = module.redis.id
  description = "The ID of the Redis Cache instance"
}

output "hostname" {
  value       = module.redis.hostname
  description = "The hostname of the Redis Cache instance"
}

output "ssl_port" {
  value       = module.redis.ssl_port
  description = "The SSL port of the Redis Cache instance"
}

output "port" {
  value       = module.redis.port
  description = "The non-SSL port of the Redis Cache instance"
}

output "primary_access_key" {
  value       = module.redis.primary_access_key
  description = "The primary access key for the Redis Cache instance"
  sensitive   = true
}

output "secondary_access_key" {
  value       = module.redis.secondary_access_key
  description = "The secondary access key for the Redis Cache instance"
  sensitive   = true
}

output "primary_connection_string" {
  value       = module.redis.primary_connection_string
  description = "The primary connection string of the Redis Cache instance"
  sensitive   = true
}

output "secondary_connection_string" {
  value       = module.redis.secondary_connection_string
  description = "The secondary connection string of the Redis Cache instance"
  sensitive   = true
}

output "redis_configuration" {
  value       = module.redis.redis_configuration
  description = "Redis configuration block applied to the cache instance"
  sensitive   = true
}

output "maxclients" {
  value       = module.redis.maxclients
  description = "Maximum number of connected clients allowed"
}

output "access_policy_id" {
  value       = module.redis.access_policy_id
  description = "The ID of the Redis Cache Access Policy"
}

output "firewall_rule_ids" {
  value       = module.redis.firewall_rule_ids
  description = "Map of Redis Firewall Rule IDs indexed by rule key"
}

output "linked_server_id" {
  value       = module.redis.linked_server_id
  description = "The ID of the Redis Linked Server"
}

output "linked_server_name" {
  value       = module.redis.linked_server_name
  description = "The name of the Redis Linked Server"
}

output "geo_replicated_primary_host_name" {
  value       = module.redis.geo_replicated_primary_host_name
  description = "The geo-replicated primary hostname of the linked server"
}
