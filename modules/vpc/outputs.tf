output "network" {
  value = google_compute_network.network.name
}

output "subnet" {
  value = element(module.vpc.subnets_names, 0)
}