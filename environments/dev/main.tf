locals {
  env = "dev"
}

provider "google" {
  project = var.project
}

module "vpc" {
  source    = "../../modules/vpc"
  project   = var.project
  env       = local.env
  region    = var.region
  locations = var.locations
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
  network = module.vpc.network
}

module "cloud_sql" {
  source = "../../modules/cloud_sql"
}