output "service_name" {
  value = [
    for cr in module.cloud_run : cr.service_name
  ]
}

output "static_ip" {
  value = google_compute_global_address.ip.address
}