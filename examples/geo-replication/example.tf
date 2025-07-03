provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current_client_config" {}

##-----------------------------------------------------------------------------
## Resource Group module call
## Resource group in which all resources will be deployed.
##-----------------------------------------------------------------------------
module "resource_group" {
  source      = "terraform-az-modules/resource-group/azure"
  version     = "1.0.0"
  name        = "core"
  environment = "dev"
  location    = "centralus"
  label_order = ["name", "environment", "location"]
}
##-----------------------------------------------------------------------------
## Secondary Resource Group module call
## Resource group in Geo Redis will be Deployed
##-----------------------------------------------------------------------------
module "secondary_resource_group" {
  source      = "terraform-az-modules/resource-group/azure"
  version     = "1.0.0"
  name        = "geo"
  environment = "dev"
  location    = "eastus"
  label_order = ["name", "environment", "location"]
}

##----------------------------------------------------------------------------- 
## ACR module call.
##-----------------------------------------------------------------------------
module "redis" {
  source                        = "../../"
  name                          = "core"
  environment                   = "dev"
  location                      = module.resource_group.resource_group_location
  resource_group_name           = module.resource_group.resource_group_name
  enable_linked_server          = true
  user_object_id                = data.azurerm_client_config.current_client_config.object_id
  secondary_enabled             = true
  secondary_location            = module.secondary_resource_group.resource_group_location
  secondary_resource_group_name = module.secondary_resource_group.resource_group_name
}
