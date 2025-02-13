# This Terragrunt module configures the ArgoCD deployment for the Europe North 1 cluster.
# It includes the necessary dependencies and inputs to set up the ArgoCD application.

include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "envcommon" {
  path   = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/argocd.hcl"
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
    cluster_name    = "mock_cluster_name"
  }
}

dependency "service_account" {
  config_path = find_in_parent_folders("service_account_argocd_secret_accessor")
  mock_outputs = {
    sa_email = "mock_sa_email"
  }
}


inputs = {
  cluster_endpoint       = dependency.k8s.outputs.cluster_server
  cluster_ca_certificate = dependency.k8s.outputs.cluster_ca_data
  cluster_name           = dependency.k8s.outputs.cluster_name
  repo_name              = "argocd-cloud-infra-test"
  repo_username          = "guicrocetti"
  branch_name            = "test"
  ARGOCD_GITHUB_TOKEN    = get_env("TF_VAR_ARGOCD_GITHUB_TOKEN")
  k8s_es_sva_name        = "gcpsm-secret"                              # kubernetes_service_account name for external-secrets
  k8s_es_sva_namespace   = "external-secrets"                          # kubernetes_service_account namespace for external-secrets
  service_account_email  = dependency.service_account.outputs.sa_email # Service account email used to access secrets
}
