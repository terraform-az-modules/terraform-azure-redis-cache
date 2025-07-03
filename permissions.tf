##-----------------------------------------------------------------------------
## Permissions, Roles, and Policies
##-----------------------------------------------------------------------------
resource "azurerm_redis_cache_access_policy_assignment" "example" {
  count              = var.enabled ? 1 : 0
  name               = format("%s-arc-assignment", module.labels.id)
  redis_cache_id     = azurerm_redis_cache.main[count.index].id
  access_policy_name = var.access_policy_name
  object_id          = var.user_object_id
  object_id_alias    = var.object_id_alias
  depends_on = [
    azurerm_redis_cache_access_policy.main
  ]
}