module "subnet_addrs" {
  source = "hashicorp/subnets/cidr"

  base_cidr_block = "10.0.0.0/22"

  for_each = toset(var.locations)
  networks = [
    {
      name     = "${var.env}-subnet-${each.key}",
      new_bits = 2
    },

  ]
}

module "vpc" {
  source = "terraform-google-modules/network/google"

  project_id   = var.project
  network_name = "${var.env}-network"

  for_each = module.subnet_addrs.networks
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

  depends_on = [
    module.subnet_addrs
  ]
}