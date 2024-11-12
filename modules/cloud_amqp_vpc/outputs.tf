output "cloudamqp_host" {
  value     = data.cloudamqp_instance.instance.host
  sensitive = false
}

output "cloudamqp_username" {
  value     = data.cloudamqp_credentials.credentials.username
  sensitive = true
}

output "cloudamqp_password" {
  value     = data.cloudamqp_credentials.credentials.password
  sensitive = true
}

output "cloudamqp_vhost" {
  value = data.cloudamqp_instance.instance.vhost
}

output "cloudamqp_vpc_gcp_info" {
  value = data.cloudamqp_vpc_gcp_info.vpc_info.network
}
