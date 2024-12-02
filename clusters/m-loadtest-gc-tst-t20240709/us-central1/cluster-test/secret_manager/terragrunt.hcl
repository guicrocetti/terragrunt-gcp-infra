include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/secret_manager.hcl"
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
  cluster_name    = dependency.k8s.outputs.cluster_name
  cluster_server  = dependency.k8s.outputs.cluster_server
  cluster_ca_data = dependency.k8s.outputs.cluster_ca_data
  secret_name     = "${dependency.k8s.outputs.cluster_name}-wrkld-0-cluster"
}