output "service_name" {
  value = [
    for cr in module.cloud_run : cr.name
  ]
}