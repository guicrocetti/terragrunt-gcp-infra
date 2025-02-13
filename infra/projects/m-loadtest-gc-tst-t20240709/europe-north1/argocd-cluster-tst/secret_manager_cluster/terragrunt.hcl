# This Terragrunt configuration sets up a Secret Manager cluster 
# for the ArgoCD cluster in the europe-north1 region.

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

inputs = {
  SECRET_DATA = jsonencode({
    name   = dependency.k8s.outputs.cluster_name
    server = dependency.k8s.outputs.cluster_server
    caData = dependency.k8s.outputs.cluster_ca_data
  })
}
