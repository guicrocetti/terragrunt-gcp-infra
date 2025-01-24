
# This is a Terragrunt module generated by boilerplate.
include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "envcommon" {
  path   = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/secret_manager.hcl"
  expose = true
}

terraform {
  source = "${include.envcommon.locals.base_source_url}?ref=${include.envcommon.locals.version}"
}

dependency "k8s" {
  config_path = find_in_parent_folders("k8s")
  mock_outputs = {
    cluster_name    = "cluster_name"
    cluster_server  = "cluster_server"
    cluster_ca_data = "cluster_ca_data"
  }
}

dependency "service_account" {
  config_path = find_in_parent_folders("service_account")
  mock_outputs = {
    sa_email = "sa_email@project_id.iam.google.com"
    sa_name  = "sa_name"
  }
}

dependency "load_balancer" {
  config_path = find_in_parent_folders("loadbalancer")
  mock_outputs = {
    loadbalancer_ip = "1.1.1.1"
  }
}

inputs = {
  SECRET_DATA = jsonencode({
    name         = dependency.k8s.outputs.cluster_name
    server       = dependency.k8s.outputs.cluster_server
    caData       = dependency.k8s.outputs.cluster_ca_data
    saEmail      = dependency.service_account.outputs.sa_email
    loadbalancer = dependency.load_balancer.outputs.loadbalancer_ip
  })
}
