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
