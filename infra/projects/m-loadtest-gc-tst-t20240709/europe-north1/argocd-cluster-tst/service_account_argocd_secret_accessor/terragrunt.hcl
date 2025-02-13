# This Terragrunt configuration creates an IAM service account named "secrets-accessor"
# The service account is used to access secrets in the ArgoCD cluster.

include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "envcommon" {
  path   = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/iam_service_account.hcl"
  expose = true
}

terraform {
  source = "${include.envcommon.locals.base_source_url}?ref=${include.envcommon.locals.version}"
}

locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
}

inputs = {
  name         = "secrets-accessor"
  display_name = "ArgoCD secrets-accessor"
  description  = "ArgoCD secrets-accessor service account by terragrunt"
}
