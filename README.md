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
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.7.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_networking"></a> [networking](#module\_networking) | github.com/hmcts/terraform-module-azure-virtual-networking | main |

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
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
| <a name="input_name"></a> [name](#input\_name) | The default name will be data-landing+env, you can override the data-landing part by setting this | `string` | `null` | no |
| <a name="input_services_subnet_address_space"></a> [services\_subnet\_address\_space](#input\_services\_subnet\_address\_space) | The address space covered by the services subnet, must be included in vnet\_address\_space. | `list(string)` | n/a | yes |
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
