

terraform {
  source = "git::https://github.com/guicrocetti/terraform-modules.git//modules/argocd"
}

include "root" {
  path = find_in_parent_folders()
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
  cluster_endpoint       = dependency.k8s.outputs.cluster_server
  cluster_ca_certificate = dependency.k8s.outputs.cluster_ca_data
}
