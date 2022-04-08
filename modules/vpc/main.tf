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
  for_each = module.subnet_addrs.network_cidr_blocks

  project_id   = var.project
  network_name = "${var.env}-network"


  subnets = [
    {
      subnet_name   = each.key
      subnet_ip     = each.value
      subnet_region = element(split("-", each.key), 2)
    }
  ]

  secondary_ranges = {
    "${each.key}" = []
  }

}