output "resource_groups" {
  value = [for rg in azurerm_resource_group.this : {
    name     = rg.name
    location = rg.location
    tags     = rg.tags
  }]
}
