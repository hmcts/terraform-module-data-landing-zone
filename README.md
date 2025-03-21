# terraform-module-data-landing-zone
Terraform module for deploying a data landing zone to Azure. Based off of [Microsoft's Bicep implementation](https://github.com/Azure/data-landing-zone) utilising existing Terraform modules and integrating with shared infrastructure to reduce cost and duplication.

## Example

<!-- todo update module name -->
```hcl
provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias                      = "ssptl"
  skip_provider_registration = true
  features {}
  subscription_id = "6c4d2513-a873-41b4-afdd-b05a33206631"
}

provider "azurerm" {
  alias                      = "cftptl"
  skip_provider_registration = true
  features {}
  subscription_id = "1baf5470-1c3e-40d3-a6f7-74bfbce4b348"
}

provider "azurerm" {
  alias                      = "soc"
  skip_provider_registration = true
  features {}
  subscription_id = "8ae5b3b6-0b12-4888-b894-4cec33c92292"
}

provider "azurerm" {
  alias                      = "cnp"
  skip_provider_registration = true
  features {}
  subscription_id = "1c4f0704-a29e-403d-b719-b90c34ef14c9"
}

module "data_landing_zone" {
  source = "../."

  providers = {
    azurerm        = azurerm
    azurerm.ssptl  = azurerm.ssptl
    azurerm.cftptl = azurerm.cftptl
    azurerm.soc    = azurerm.soc
    azurerm.cnp    = azurerm.cnp
  }

  env                                              = var.env
  common_tags                                      = var.common_tags
  default_route_next_hop_ip                        = var.default_route_next_hop_ip
  vnet_address_space                               = ["10.10.0.0/20"]
  services_subnet_address_space                    = ["10.10.1.0/24"]
  services_mysql_subnet_address_space              = ["10.10.2.0/24"]
  data_bricks_public_subnet_address_space          = ["10.10.3.0/24"]
  data_bricks_private_subnet_address_space         = ["10.10.4.0/24"]
  data_bricks_product_public_subnet_address_space  = ["10.10.5.0/24"]
  data_bricks_product_private_subnet_address_space = ["10.10.6.0/24"]
  data_integration_001_subnet_address_space        = ["10.10.7.0/24"]
  data_integration_002_subnet_address_space        = ["10.10.8.0/24"]
  data_product_001_subnet_address_space            = ["10.10.9.0/24"]
  data_product_002_subnet_address_space            = ["10.10.10.0/24"]
}

```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | >= 2.43.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.116.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | >= 2.43.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.116.0 |
| <a name="provider_azurerm.cftptl"></a> [azurerm.cftptl](#provider\_azurerm.cftptl) | >= 3.116.0 |
| <a name="provider_azurerm.ssptl"></a> [azurerm.ssptl](#provider\_azurerm.ssptl) | >= 3.116.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_legacy_database"></a> [legacy\_database](#module\_legacy\_database) | github.com/hmcts/terraform-module-virtual-machine.git | master |
| <a name="module_logging_vault"></a> [logging\_vault](#module\_logging\_vault) | github.com/hmcts/cnp-module-key-vault | master |
| <a name="module_logging_vault_pe"></a> [logging\_vault\_pe](#module\_logging\_vault\_pe) | ./modules/azure-private-endpoint | n/a |
| <a name="module_metadata_mssql"></a> [metadata\_mssql](#module\_metadata\_mssql) | github.com/hmcts/terraform-module-mssql | main |
| <a name="module_metadata_mysql"></a> [metadata\_mysql](#module\_metadata\_mysql) | github.com/hmcts/terraform-module-mysql-flexible | main |
| <a name="module_metadata_vault"></a> [metadata\_vault](#module\_metadata\_vault) | github.com/hmcts/cnp-module-key-vault | master |
| <a name="module_metadata_vault_pe"></a> [metadata\_vault\_pe](#module\_metadata\_vault\_pe) | ./modules/azure-private-endpoint | n/a |
| <a name="module_networking"></a> [networking](#module\_networking) | github.com/hmcts/terraform-module-azure-virtual-networking | 4.x |
| <a name="module_runtimes_datafactory"></a> [runtimes\_datafactory](#module\_runtimes\_datafactory) | github.com/hmcts/terraform-module-azure-datafactory | main |
| <a name="module_shared_integration_databricks"></a> [shared\_integration\_databricks](#module\_shared\_integration\_databricks) | github.com/hmcts/terraform-module-databricks | main |
| <a name="module_shared_integration_datafactory"></a> [shared\_integration\_datafactory](#module\_shared\_integration\_datafactory) | github.com/hmcts/terraform-module-azure-datafactory | main |
| <a name="module_shared_integration_eventhub_pe"></a> [shared\_integration\_eventhub\_pe](#module\_shared\_integration\_eventhub\_pe) | ./modules/azure-private-endpoint | n/a |
| <a name="module_shared_product_databricks"></a> [shared\_product\_databricks](#module\_shared\_product\_databricks) | github.com/hmcts/terraform-module-databricks | main |
| <a name="module_shir001"></a> [shir001](#module\_shir001) | ./modules/self-hosted-integration-runtime | n/a |
| <a name="module_shir002"></a> [shir002](#module\_shir002) | ./modules/self-hosted-integration-runtime | n/a |
| <a name="module_storage"></a> [storage](#module\_storage) | github.com/hmcts/cnp-module-storage-account | feat%2Finfra-encryption-4.x |
| <a name="module_storage_pe"></a> [storage\_pe](#module\_storage\_pe) | ./modules/azure-private-endpoint | n/a |
| <a name="module_synapse_pe"></a> [synapse\_pe](#module\_synapse\_pe) | ./modules/azure-private-endpoint | n/a |
| <a name="module_vnet_peer_hub"></a> [vnet\_peer\_hub](#module\_vnet\_peer\_hub) | github.com/hmcts/terraform-module-vnet-peering | feat%2Ftweak-to-enable-planning-in-a-clean-env |

## Resources

| Name | Type |
|------|------|
| [azurerm_bastion_host.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/bastion_host) | resource |
| [azurerm_data_factory_integration_runtime_self_hosted.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_integration_runtime_self_hosted) | resource |
| [azurerm_eventhub_namespace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub_namespace) | resource |
| [azurerm_key_vault_access_policy.logging_vault_reders](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.metadata_vault_reders](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_secret.legacy_database_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.legacy_database_username](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.log_analytics_workspace_id](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.log_analytics_workspace_secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.mssql_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.mssql_username](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.mysql_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.mysql_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.mysql_username](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.synapse_sql_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.synapse_sql_username](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_log_analytics_workspace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_monitor_diagnostic_setting.runtimes_datafactory](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_setting.shared_integration_datafactory](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_private_dns_zone_virtual_network_link.data_landing_link](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_public_ip.bastion](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_public_ip.legacy_pip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.datafactory_databricks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.runtimes_datafactory_storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.shared_integration_datafactory_storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_storage_data_lake_gen2_filesystem.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_data_lake_gen2_filesystem) | resource |
| [azurerm_storage_management_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_management_policy) | resource |
| [azurerm_synapse_spark_pool.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_spark_pool) | resource |
| [azurerm_synapse_sql_pool.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_sql_pool) | resource |
| [azurerm_synapse_workspace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_workspace) | resource |
| [azurerm_synapse_workspace_aad_admin.aad](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_workspace_aad_admin) | resource |
| [random_password.legacy_database_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.synapse_sql_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_string.legacy_database_username](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [azuread_group.admin_group](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_private_dns_zone.cftptl](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_subnet.ssptl-00](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_subnet.ssptl-01](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_nsg_rules"></a> [additional\_nsg\_rules](#input\_additional\_nsg\_rules) | Map of additional NSG rules to create, keyed by the rule name. | <pre>map(object({<br/>    name_override                              = optional(string)<br/>    priority                                   = number<br/>    direction                                  = string<br/>    access                                     = string<br/>    protocol                                   = string<br/>    source_port_range                          = optional(string)<br/>    source_port_ranges                         = optional(list(string))<br/>    destination_port_range                     = optional(string)<br/>    destination_port_ranges                    = optional(list(string))<br/>    source_address_prefix                      = optional(string)<br/>    source_address_prefixes                    = optional(list(string))<br/>    source_application_security_group_ids      = optional(list(string))<br/>    destination_address_prefix                 = optional(string)<br/>    destination_address_prefixes               = optional(list(string))<br/>    destination_application_security_group_ids = optional(list(string))<br/>    description                                = optional(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_additional_subnets"></a> [additional\_subnets](#input\_additional\_subnets) | Map of additional subnets to create, keyed by the subnet name. | <pre>map(object({<br/>    name_override     = optional(string)<br/>    address_prefixes  = list(string)<br/>    service_endpoints = optional(list(string), [])<br/>    delegations = optional(map(object({<br/>      service_name = string,<br/>      actions      = optional(list(string), [])<br/>    })))<br/>  }))</pre> | `{}` | no |
| <a name="input_adf_deploy_purview_private_endpoints"></a> [adf\_deploy\_purview\_private\_endpoints](#input\_adf\_deploy\_purview\_private\_endpoints) | Whether to deploy a private endpoint for the ADF to Purview connection. Defaults to false. | `bool` | `true` | no |
| <a name="input_bastion_host_source_ip_allowlist"></a> [bastion\_host\_source\_ip\_allowlist](#input\_bastion\_host\_source\_ip\_allowlist) | The list of IP addresses that are allowed to connect to the bastion host. | `list(string)` | `[]` | no |
| <a name="input_bastion_host_subnet_address_space"></a> [bastion\_host\_subnet\_address\_space](#input\_bastion\_host\_subnet\_address\_space) | The address space covered by the bastion host subnet, must be included in vnet\_address\_space. Minimum of /26 | `list(string)` | `null` | no |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | Common tag to be applied to resources | `map(string)` | n/a | yes |
| <a name="input_data_bricks_private_subnet_address_space"></a> [data\_bricks\_private\_subnet\_address\_space](#input\_data\_bricks\_private\_subnet\_address\_space) | The address space covered by the data bricks private subnet, must be included in vnet\_address\_space. | `list(string)` | n/a | yes |
| <a name="input_data_bricks_product_private_subnet_address_space"></a> [data\_bricks\_product\_private\_subnet\_address\_space](#input\_data\_bricks\_product\_private\_subnet\_address\_space) | The address space covered by the data bricks product private subnet, must be included in vnet\_address\_space. | `list(string)` | n/a | yes |
| <a name="input_data_bricks_product_public_subnet_address_space"></a> [data\_bricks\_product\_public\_subnet\_address\_space](#input\_data\_bricks\_product\_public\_subnet\_address\_space) | The address space covered by the data bricks product public subnet, must be included in vnet\_address\_space. | `list(string)` | n/a | yes |
| <a name="input_data_bricks_public_subnet_address_space"></a> [data\_bricks\_public\_subnet\_address\_space](#input\_data\_bricks\_public\_subnet\_address\_space) | The address space covered by the data bricks public subnet, must be included in vnet\_address\_space. | `list(string)` | n/a | yes |
| <a name="input_data_integration_001_subnet_address_space"></a> [data\_integration\_001\_subnet\_address\_space](#input\_data\_integration\_001\_subnet\_address\_space) | The address space covered by the data integration 001 subnet, must be included in vnet\_address\_space. | `list(string)` | n/a | yes |
| <a name="input_data_integration_002_subnet_address_space"></a> [data\_integration\_002\_subnet\_address\_space](#input\_data\_integration\_002\_subnet\_address\_space) | The address space covered by the data integration 002 subnet, must be included in vnet\_address\_space. | `list(string)` | n/a | yes |
| <a name="input_data_product_001_subnet_address_space"></a> [data\_product\_001\_subnet\_address\_space](#input\_data\_product\_001\_subnet\_address\_space) | The address space covered by the data product 001 subnet, must be included in vnet\_address\_space. | `list(string)` | n/a | yes |
| <a name="input_data_product_002_subnet_address_space"></a> [data\_product\_002\_subnet\_address\_space](#input\_data\_product\_002\_subnet\_address\_space) | The address space covered by the data product 002 subnet, must be included in vnet\_address\_space. | `list(string)` | n/a | yes |
| <a name="input_default_route_next_hop_ip"></a> [default\_route\_next\_hop\_ip](#input\_default\_route\_next\_hop\_ip) | The IP address of the private ip configuration of the Hub Palo load balancer. | `string` | n/a | yes |
| <a name="input_enable_synapse_spark_pool"></a> [enable\_synapse\_spark\_pool](#input\_enable\_synapse\_spark\_pool) | Whether to deploy a Synapse Spark pool. Defaults to false. | `bool` | `false` | no |
| <a name="input_enable_synapse_sql_pool"></a> [enable\_synapse\_sql\_pool](#input\_enable\_synapse\_sql\_pool) | Whether to deploy a Synapse SQL pool. Defaults to false. | `bool` | `false` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment value | `string` | n/a | yes |
| <a name="input_existing_purview_account"></a> [existing\_purview\_account](#input\_existing\_purview\_account) | Details of an existing purview account to use, if not specified a new one will be created. | <pre>object({<br/>    resource_id                              = string<br/>    managed_storage_account_id               = optional(string)<br/>    managed_event_hub_namespace_id           = optional(string)<br/>    self_hosted_integration_runtime_auth_key = optional(string)<br/>    identity = object({<br/>      principal_id = string<br/>      tenant_id    = string<br/>    })<br/>  })</pre> | `null` | no |
| <a name="input_existing_resource_group_name"></a> [existing\_resource\_group\_name](#input\_existing\_resource\_group\_name) | Name of existing resource group to deploy resources into | `string` | `null` | no |
| <a name="input_github_configuration"></a> [github\_configuration](#input\_github\_configuration) | Optional GitHub configuration settings for the Azure Data Factory. | <pre>map(object({<br/>    branch_name        = string<br/>    git_url            = string<br/>    repository_name    = string<br/>    root_folder        = string<br/>    publishing_enabled = bool<br/>  }))</pre> | `{}` | no |
| <a name="input_hub_resource_group_name"></a> [hub\_resource\_group\_name](#input\_hub\_resource\_group\_name) | The name of the resource group containing the HUB virtual network. | `string` | n/a | yes |
| <a name="input_hub_vnet_name"></a> [hub\_vnet\_name](#input\_hub\_vnet\_name) | The name of the HUB virtual network. | `string` | n/a | yes |
| <a name="input_install_azure_monitor"></a> [install\_azure\_monitor](#input\_install\_azure\_monitor) | Install Azure Monitor Agent. | `bool` | `false` | no |
| <a name="input_key_vault_readers"></a> [key\_vault\_readers](#input\_key\_vault\_readers) | List of strings representing the object ids of the users or groups that should have read access to the key vault. | `list(string)` | `[]` | no |
| <a name="input_legacy_databases"></a> [legacy\_databases](#input\_legacy\_databases) | Map of legacy databases to create as IaaS VMs. | <pre>map(object({<br/>    size           = optional(string, "Standard_D4ds_v5")<br/>    type           = optional(string, "windows")<br/>    public_ip      = optional(bool, false)<br/>    computer_name  = optional(string)<br/>    publisher_name = string<br/>    offer          = string<br/>    sku            = string<br/>    version        = string<br/>  }))</pre> | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | Target Azure location to deploy the resource | `string` | `"UK South"` | no |
| <a name="input_log_analytics_sku"></a> [log\_analytics\_sku](#input\_log\_analytics\_sku) | The sku of the log analytics workspace, will default to PerGB2018. | `string` | `"PerGB2018"` | no |
| <a name="input_name"></a> [name](#input\_name) | The default name will be data-landing+env, you can override the data-landing part by setting this | `string` | `null` | no |
| <a name="input_services_mysql_subnet_address_space"></a> [services\_mysql\_subnet\_address\_space](#input\_services\_mysql\_subnet\_address\_space) | The address space covered by the services-mysql subnet, must be included in vnet\_address\_space. This is delegated to MySQL Flexible Server. | `list(string)` | n/a | yes |
| <a name="input_services_subnet_address_space"></a> [services\_subnet\_address\_space](#input\_services\_subnet\_address\_space) | The address space covered by the services subnet, must be included in vnet\_address\_space. | `list(string)` | n/a | yes |
| <a name="input_storage_account_kind"></a> [storage\_account\_kind](#input\_storage\_account\_kind) | The storage account kind, will default to StorageV2. | `string` | `"StorageV2"` | no |
| <a name="input_storage_account_replication_type"></a> [storage\_account\_replication\_type](#input\_storage\_account\_replication\_type) | The replication type of the storage account, will default to LRS. | `string` | `"LRS"` | no |
| <a name="input_storage_account_tier"></a> [storage\_account\_tier](#input\_storage\_account\_tier) | The storage account tier, will default to Standard. | `string` | `"Standard"` | no |
| <a name="input_systemassigned_identity"></a> [systemassigned\_identity](#input\_systemassigned\_identity) | Assign System identity | `bool` | `false` | no |
| <a name="input_use_microsoft_ip_kit_structure"></a> [use\_microsoft\_ip\_kit\_structure](#input\_use\_microsoft\_ip\_kit\_structure) | Whether to use the Microsoft IP Kit structure for the network. Defaults to false. | `bool` | `false` | no |
| <a name="input_vnet_address_space"></a> [vnet\_address\_space](#input\_vnet\_address\_space) | The Address space covered by the data landing zone virtual network | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_metadata_mssql"></a> [metadata\_mssql](#output\_metadata\_mssql) | n/a |
| <a name="output_resource_groups"></a> [resource\_groups](#output\_resource\_groups) | n/a |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | n/a |
<!-- END_TF_DOCS -->

## Contributing

We use pre-commit hooks for validating the terraform format and maintaining the documentation automatically.
Install it with:

```shell
$ brew install pre-commit terraform-docs
$ pre-commit install
```

If you add a new hook make sure to run it against all files:
```shell
$ pre-commit run --all-files
```
