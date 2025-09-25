provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current_client_config" {}

module "resource_group" {
  source      = "terraform-az-modules/resource-group/azure"
  version     = "1.0.0"
  name        = "core"
  environment = "dev"
  location    = "centralus"
  label_order = ["name", "environment", "location"]
}

# ------------------------------------------------------------------------------
# Virtual Network
# ------------------------------------------------------------------------------
module "vnet" {
  source              = "terraform-az-modules/vnet/azure"
  version             = "1.0.0"
  name                = "core"
  environment         = "dev"
  label_order         = ["name", "environment", "location"]
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  address_spaces      = ["10.0.0.0/16"]
}

# ------------------------------------------------------------------------------
# Subnet
# ------------------------------------------------------------------------------
module "subnet" {
  source               = "terraform-az-modules/subnet/azure"
  version              = "1.0.0"
  environment          = "dev"
  label_order          = ["name", "environment", "location"]
  resource_group_name  = module.resource_group.resource_group_name
  location             = module.resource_group.resource_group_location
  virtual_network_name = module.vnet.vnet_name
  subnets = [
    {
      name            = "subnet1"
      subnet_prefixes = ["10.0.1.0/24"]
    }
  ]
}

# ------------------------------------------------------------------------------
# Log Analytics
# ------------------------------------------------------------------------------
module "log-analytics" {
  source                      = "terraform-az-modules/log-analytics/azure"
  version                     = "1.0.0"
  name                        = "core"
  environment                 = "dev"
  label_order                 = ["name", "environment", "location"]
  log_analytics_workspace_sku = "PerGB2018"
  resource_group_name         = module.resource_group.resource_group_name
  location                    = module.resource_group.resource_group_location
}

# ------------------------------------------------------------------------------
# Private DNS Zone
# ------------------------------------------------------------------------------
module "private_dns_zone" {
  source              = "terraform-az-modules/private-dns/azure"
  version             = "1.0.0"
  name                = "core"
  environment         = "dev"
  label_order         = ["name", "environment", "location"]
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  private_dns_config = [
    {
      resource_type = "azure_redis"
      vnet_ids      = [module.vnet.vnet_id]
    }
  ]
}

##----------------------------------------------------------------------------- 
## Redis module call.
##-----------------------------------------------------------------------------
module "redis" {
  depends_on                 = [module.private_dns_zone]
  source                     = "../../"
  name                       = "core"
  environment                = "dev"
  location                   = module.resource_group.resource_group_location
  private_dns_zone_ids       = module.private_dns_zone.private_dns_zone_ids.azure_redis
  resource_group_name        = module.resource_group.resource_group_name
  user_object_id             = data.azurerm_client_config.current_client_config.object_id
  log_analytics_workspace_id = module.log-analytics.workspace_id
  subnet_id                  = module.subnet.subnet_ids.subnet1
}
