output "resource_groups" {
  value = [for rg in azurerm_resource_group.this : {
    name     = rg.name
    location = rg.location
    id       = rg.id
  }]
}

output "subnet_ids" {
  value = module.networking.subnet_ids
}
