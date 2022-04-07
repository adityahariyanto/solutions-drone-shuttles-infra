output "network" {
  value = module.vpc.network
}

output "subnet" {
  value = module.vpc.subnet
}

output "service_name" {
  value = module.cloud_run.service_name
}