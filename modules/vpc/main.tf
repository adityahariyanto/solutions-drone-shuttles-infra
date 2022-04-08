module "subnet_addrs" {
  source = "hashicorp/subnets/cidr"

  base_cidr_block = "10.0.0.0/22"

  for_each = toset(var.locations)
  networks = [
    {
      name     = "${var.env}-subnet-${each.key}",
      new_bits = 2
    }

  ]
}

resource "google_compute_network" "network" {
  name                            = "${var.env}-network"
  project                         = var.project
  auto_create_subnetworks         = false
  routing_mode                    = global
  mtu                             = 1460
  delete_default_routes_on_create = true
}

resource "google_compute_subnetwork" "subnet" {
  for_each = module.subnet_addrs.network

  name          = each.key
  ip_cidr_range = each.value
  network       = google_compute_network.network.name
  region        = element(split("-", var.subnet), 2)
}
module "vpc" {
  source = "terraform-google-modules/network/google"

  project_id   = var.project
  network_name = "${var.env}-network"

  for_each = module.subnet_addrs.network
  subnets = [
    {
      subnet_name   = each.key
      subnet_ip     = each.value
      subnet_region = element(split("-", each.key), 2)
    },
  ]

  secondary_ranges = {
    "${each.key}" = []
  }
}