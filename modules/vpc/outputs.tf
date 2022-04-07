output "network" {
  value = module.network.name
}

output "subnet" {
  value = element(module.vpc.subnets_names, 0)
}