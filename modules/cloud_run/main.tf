module "cloud_run" {
  source = "GoogleCloudPlatform/cloud-run/google"

  for_each = toset(var.locations)

  service_name = "ghost-svc-${each.key}"
  project_id   = var.project
  location     = each.key
  image        = var.image
  ports = {
    "name" : "http1",
    "port" : 2368
  }

  service_annotations = {
    "run.googleapis.com/ingress" : "internal-and-cloud-load-balancing"
  }
}

resource "google_compute_global_address" "ip" {
  name = "${var.env}-service-ip"
}

resource "google_compute_region_network_endpoint_group" "neg" {
  for_each = toset(var.locations)

  name                  = "neg-${each.key}"
  network_endpoint_type = "SERVERLESS"
  region                = each.key

  cloud_run {
    service = module.cloud_run[each.key].service_name
  }
}

resource "google_compute_backend_service" "backend" {
  name     = "${var.env}-backend"
  protocol = "HTTP"

  dynamic "backend" {
    for_each = toset(var.locations)

    content {
      group = google_compute_region_network_endpoint_group.neg[backend.key].id
    }
  }

}

resource "google_compute_url_map" "url_map" {
  name            = "${var.env}-url-map"
  default_service = google_compute_backend_service.backend.id
}

resource "google_compute_target_http_proxy" "http_proxy" {
  name    = "${var.env}-http-proxy"
  url_map = google_compute_url_map.url_map.id
}

resource "google_compute_global_forwarding_rule" "frontend" {
  name       = "${var.env}-frontend"
  target     = google_compute_target_http_proxy.http_proxy.id
  port_range = "80"
  ip_address = google_compute_global_address.ip.address
}

data "google_iam_policy" "noauth" {
  binding {
    role    = "roles/run.invoker"
    members = ["allUsers"]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  for_each = toset(var.locations)

  service     = module.cloud_run[each.key].service_name
  location    = module.cloud_run[each.key].location
  policy_data = data.google_iam_policy.noauth.policy_data
}