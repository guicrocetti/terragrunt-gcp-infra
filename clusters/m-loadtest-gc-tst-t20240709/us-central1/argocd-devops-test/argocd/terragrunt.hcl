include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/argocd.hcl"
  expose = true
}

terraform {
  source = "${include.envcommon.locals.base_source_url}?ref=${include.envcommon.locals.version}"
}

dependency "k8s" {
  config_path = find_in_parent_folders("k8s")
  mock_outputs = {
    cluster_server  = "mock_cluster_server"
    cluster_ca_data = "mock_cluster_ca"
  }
}

inputs = {
  cluster_endpoint       = dependency.k8s.outputs.cluster_server
  cluster_ca_certificate = dependency.k8s.outputs.cluster_ca_data
  repository_name        = "guicrocetti/argocd-cloud-infra-test"
  repo_username          = "guicrocetti"
}
