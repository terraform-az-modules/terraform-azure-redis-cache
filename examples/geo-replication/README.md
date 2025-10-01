<!-- BEGIN_TF_DOCS -->

# Terraform Azure Redis Cache

This directory contains an example usage of the **terraform-azure-redis-cache**. It demonstrates how to use the module with geo-replication.

---

## 📋 Requirements

| Name      | Version   |
|-----------|-----------|
| Terraform | >= 1.6.6  |
| Azurerm   | >= 3.116.0|

---

## 🔌 Providers

None specified in this example.

---

## 📦 Modules

| Name            | Source                              | Version |
|-----------------|-------------------------------------|---------|
| resource_group  | terraform-az-modules/resource-group/azure    | 1.0.0   |
| secondary_resource_group  | terraform-az-modules/resource-group/azure    | 1.0.0   |
| redis            | ../../                              | n/a     |


---

## 🏗️ Resources

No resources are directly created in this example.

---

## 🔧 Inputs

No input variables are defined in this example.

---

## 📤 Outputs

| Name                               | Description                                                 |
| ---------------------------------- | ----------------------------------------------------------- |
| `id`                               | The ID of the Redis Cache instance                          |
| `hostname`                         | The hostname of the Redis Cache instance                    |
| `ssl_port`                         | The SSL port of the Redis Cache instance                    |
| `port`                             | The non-SSL port of the Redis Cache instance                |
| `primary_access_key`               | The primary access key for the Redis Cache instance         |
| `secondary_access_key`             | The secondary access key for the Redis Cache instance       |
| `primary_connection_string`        | The primary connection string of the Redis Cache instance   |
| `secondary_connection_string`      | The secondary connection string of the Redis Cache instance |
| `redis_configuration`              | Redis configuration block applied to the cache instance     |
| `maxclients`                       | Maximum number of connected clients allowed                 |
| `access_policy_id`                 | The ID of the Redis Cache Access Policy                     |
| `firewall_rule_ids`                | Map of Redis Firewall Rule IDs indexed by rule key          |
| `linked_server_id`                 | The ID of the Redis Linked Server                           |
| `linked_server_name`               | The name of the Redis Linked Server                         |
| `geo_replicated_primary_host_name` | The geo-replicated primary hostname of the linked server    |


<!-- END_TF_DOCS -->
