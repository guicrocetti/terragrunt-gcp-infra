# This Terragrunt configuration sets up a Secret Manager resource in the ArgoCD cluster in the europe-north1 region. 
# The secret is named "repo-password" and has a label of "argo_repo_password". 
# The value of the secret is obtained from the TF_VAR_ARGOCD_GITHUB_TOKEN environment variable.

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

inputs = {
  secret_name = "repo-password"
  labels = {
    label       = "argo-repo-password"
    environment = "prod"
    service     = "argocd-mgmt-prod"
  }
  SECRET_DATA = get_env("TF_VAR_ARGOCD_GITHUB_TOKEN")
}
