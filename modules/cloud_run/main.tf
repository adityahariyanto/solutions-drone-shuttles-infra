module "cloud_run" {
  source = "GoogleCloudPlatform/cloud-run/google"

  for_each = toset(var.locations)

  service_name = "ghost-svc-${each.key}"
  project_id   = var.project
  location     = each.key
  image        = var.image
  ports = {
      "name": "http1"
      "port": 2368
  }
}

resource "google_compute_global_adress" "ip" {
  name = "${var.env}-service-ip"
}

resource "google_compute_region_network_endpoint_group" "neg" {
  for_each = toset(var.locations)

  name = "neg-${each.key}"
  network_endpoint_type = "SERVERLESS"
  region = each.key

  cloud_run {
    service = module.cloud_run[each.key].service_name
  }
}