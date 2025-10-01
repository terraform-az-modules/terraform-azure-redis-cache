##-----------------------------------------------------------------------------
## Permissions, Roles, and Policies
##-----------------------------------------------------------------------------
# Assigns an Azure AD identity to a Redis data access policy (enabling fine-grained, identity-based access instead of shared keys)
resource "azurerm_redis_cache_access_policy_assignment" "identity_assigned" {
  count              = var.enable && var.user_object_id != null ? 1 : 0
  name               = format("%s-arc-assignment", module.labels.id)
  redis_cache_id     = azurerm_redis_cache.main[count.index].id
  access_policy_name = var.access_policy_name
  object_id          = var.user_object_id
  object_id_alias    = var.object_id_alias
}