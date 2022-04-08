module "subnet_addrs" {
  source   = "hashicorp/subnets/cidr"
  for_each = toset(var.locations)

  base_cidr_block = "10.0.0.0/16"

  networks = [
    {
      name     = "${var.env}-subnet-${each.key}",
      new_bits = 8
    }
  ]
}

module "vpc" {
  source   = "terraform-google-modules/network/google"
#   for_each = module.subnet_addrs.network_cidr_blocks

  project_id   = var.project
  network_name = "${var.env}-network"


  subnets = [
      for n in module.subnet_addrs.networks : {
      subnet_name   = n.name
      subnet_ip     = n.cidr_block
      subnet_region = element(split("-", n.name), 2)
    }

    if n.cidr_block != null
  ]

  secondary_ranges = {
    "${each.key}" = []
  }

}