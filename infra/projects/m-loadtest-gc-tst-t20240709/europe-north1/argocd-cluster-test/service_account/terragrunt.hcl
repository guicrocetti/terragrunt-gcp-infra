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
  name         = "argocd-sa-adm"
  display_name = "ArgoCD service account by terragrunt"
  description  = "ArgoCD service account by terragrunt"
}
