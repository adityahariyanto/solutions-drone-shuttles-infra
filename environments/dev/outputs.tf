output "network" {
  value = module.vpc.network
}

# output "subnet" {
#   value = module.vpc.subnet
# }

output "service_name" {
  value = module.cloud_run.service_name
}

output "firewall_rule" {
  value = module.firewall.firewall_rule
}

output "external_ip" {
  value = module.cloud_run.static_ip
}