module "data_landing_zone" {
  source = "../."

  env                                              = var.env
  common_tags                                      = var.common_tags
  default_route_next_hop_ip                        = var.default_route_next_hop_ip
  vnet_address_space                               = ["10.10.0.0/20"]
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
