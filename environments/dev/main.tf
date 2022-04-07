locals {
  env = "dev"
}

provider "google" {
  project = var.project
}

module "vpc" {
  source  = "../../modules/vpc"
  project = var.project
  env     = local.env
  region  = var.region
}

module "cloud_run" {
  source    = "../../modules/cloud_run"
  project   = var.project
  env       = local.env
  locations = var.locations
  image     = var.image
}

module "firewall" {
  source  = "../../modules/firewall"
  project = var.project
  subnet  = module.vpc.subnet
}