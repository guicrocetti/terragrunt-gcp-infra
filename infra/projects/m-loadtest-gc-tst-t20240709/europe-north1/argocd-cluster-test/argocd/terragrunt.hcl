
# This is a Terragrunt module generated by boilerplate.
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
  }
}

dependency "service_account" {
  config_path = find_in_parent_folders("service_account")
  mock_outputs = {
    sa_email = "mock_sa_email"
  }
}

# if using project_level service account
# locals {
#   account_vars          = read_terragrunt_config(find_in_parent_folders("account.hcl"))
#   service_account_name  = local.account_vars.locals.service_account
#   project_id            = local.account_vars.locals.project_id
#   service_account_email = "${local.service_account_name}@${local.project_id}.iam.gserviceaccount.com"
# }

inputs = {
  cluster_endpoint       = dependency.k8s.outputs.cluster_server
  cluster_ca_certificate = dependency.k8s.outputs.cluster_ca_data
  cluster_name           = dependency.k8s.outputs.cluster_name
  repo_name              = "argocd-cloud-infra-test"
  repo_username          = "guicrocetti"
  environment            = "main"
  ARGOCD_GITHUB_TOKEN    = get_env("TF_VAR_ARGOCD_GITHUB_TOKEN")
  k8s_es_sva_name        = "gcpsm-secret"
  k8s_es_sva_namespace   = "external-secrets"
  service_account_email  = dependency.service_account.outputs.sa_email
}
