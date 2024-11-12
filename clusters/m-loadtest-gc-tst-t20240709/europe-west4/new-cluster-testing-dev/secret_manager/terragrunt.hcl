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
    cluster_name    = "mock_cluster_name"
    cluster_server  = "mock_cluster_server"
    cluster_ca_data = "mock_cluster_ca_data"
  }
}


inputs = {
  # All configurations here will have precedence over the default
  cluster_name    = dependency.k8s.outputs.cluster_name
  cluster_server  = dependency.k8s.outputs.cluster_server
  cluster_ca_data = dependency.k8s.outputs.cluster_ca_data
}
