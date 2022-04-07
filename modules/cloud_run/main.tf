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