# terraform-module-data-landing-zone
Terraform module for deploying a data landing zone to Azure. Based off of [Microsoft's Bicep implementation](https://github.com/Azure/data-landing-zone) utilising existing Terraform modules and integrating with shared infrastructure to reduce cost and duplication.

## Example

<!-- todo update module name -->
```hcl
module "data_landing_zone" {
  source = "../."

  env                                              = var.env
  common_tags                                      = var.common_tags
  default_route_next_hop_ip                        = var.default_route_next_hop_ip
  vnet_address_space                               = ["10.10.1.0/20"]
  services_subnet_address_space                    = ["10.10.1.0/24"]
  data_bricks_public_subnet_address_space          = ["10.10.2.0/24"]
  data_bricks_private_subnet_address_space         = ["10.10.3.0/24"]
  data_bricks_product_public_subnet_address_space  = ["10.10.4.0/24"]
  data_bricks_product_private_subnet_address_space = ["10.10.5.0/24"]
  data_integration_001_subnet_address_space        = ["10.10.6.0/24"]
  data_integration_002_subnet_address_space        = ["10.10.7.0/24"]
  data_product_001_subnet_address_space            = ["10.10.8.0/24"]
  data_product_002_subnet_address_space            = ["10.10.9.0/24"]
}

```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | >= 2.43.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | >= 2.43.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.74.0 |
| <a name="provider_azurerm.cftptl"></a> [azurerm.cftptl](#provider\_azurerm.cftptl) | 3.74.0 |
| <a name="provider_azurerm.ssptl"></a> [azurerm.ssptl](#provider\_azurerm.ssptl) | 3.74.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_logging_vault"></a> [logging\_vault](#module\_logging\_vault) | github.com/hmcts/cnp-module-key-vault | master |
| <a name="module_metadata_mssql"></a> [metadata\_mssql](#module\_metadata\_mssql) | github.com/hmcts/terraform-module-mssql | main |
| <a name="module_metadata_mysql"></a> [metadata\_mysql](#module\_metadata\_mysql) | github.com/hmcts/terraform-module-mysql-flexible | main |
| <a name="module_metadata_vault"></a> [metadata\_vault](#module\_metadata\_vault) | github.com/hmcts/cnp-module-key-vault | master |
| <a name="module_networking"></a> [networking](#module\_networking) | github.com/hmcts/terraform-module-azure-virtual-networking | main |
| <a name="module_storage"></a> [storage](#module\_storage) | github.com/hmcts/cnp-module-storage-account | master |

## Resources

| Name | Type |
|------|------|
| [azurerm_databricks_workspace.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/databricks_workspace) | resource |
| [azurerm_key_vault_secret.log_analytics_workspace_id](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.log_analytics_workspace_secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.mssql_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.mssql_username](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.mysql_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.mysql_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.mysql_username](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_log_analytics_workspace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_private_dns_zone_virtual_network_link.data_landing_link](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_endpoint.logging_vault_pe](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.metadata_vault_pe](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.storage_pe](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_resource_group.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_storage_management_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_management_policy) | resource |
| [azurerm_synapse_workspace.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_workspace) | resource |
| [azuread_group.admin_group](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_private_dns_zone.cftptl](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_subnet.ssptl-00](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_subnet.ssptl-01](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
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
| <a name="input_env"></a> [env](#input\_env) | Environment value | `string` | n/a | yes |
| <a name="input_existing_resource_group_name"></a> [existing\_resource\_group\_name](#input\_existing\_resource\_group\_name) | Name of existing resource group to deploy resources into | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | Target Azure location to deploy the resource | `string` | `"UK South"` | no |
| <a name="input_log_analytics_sku"></a> [log\_analytics\_sku](#input\_log\_analytics\_sku) | The sku of the log analytics workspace, will default to PerGB2018. | `string` | `"PerGB2018"` | no |
| <a name="input_name"></a> [name](#input\_name) | The default name will be data-landing+env, you can override the data-landing part by setting this | `string` | `null` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Specifies the prefix for all resources created in this deployment | `string` | `"prefix"` | no |
| <a name="input_purview_id"></a> [purview\_id](#input\_purview\_id) | The ID of Azure purview account | `string` | `"/subscriptions/a8140a9e-f1b0-481f-a4de-09e2ee23f7ab/resourceGroups/mi-sbox-rg/providers/Microsoft.Purview/accounts/mi-purview-sbox"` | no |
| <a name="input_services_mysql_subnet_address_space"></a> [services\_mysql\_subnet\_address\_space](#input\_services\_mysql\_subnet\_address\_space) | The address space covered by the services-mysql subnet, must be included in vnet\_address\_space. This is delegated to MySQL Flexible Server. | `list(string)` | n/a | yes |
| <a name="input_services_subnet_address_space"></a> [services\_subnet\_address\_space](#input\_services\_subnet\_address\_space) | The address space covered by the services subnet, must be included in vnet\_address\_space. | `list(string)` | n/a | yes |
| <a name="input_storage_account_kind"></a> [storage\_account\_kind](#input\_storage\_account\_kind) | The storage account kind, will default to StorageV2. | `string` | `"StorageV2"` | no |
| <a name="input_storage_account_replication_type"></a> [storage\_account\_replication\_type](#input\_storage\_account\_replication\_type) | The replication type of the storage account, will default to LRS. | `string` | `"LRS"` | no |
| <a name="input_storage_account_tier"></a> [storage\_account\_tier](#input\_storage\_account\_tier) | The storage account tier, will default to Standard. | `string` | `"Standard"` | no |
| <a name="input_vnet_address_space"></a> [vnet\_address\_space](#input\_vnet\_address\_space) | The Address space covered by the data landing zone virtual network | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_resource_group_location"></a> [resource\_group\_location](#output\_resource\_group\_location) | n/a |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | n/a |
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
