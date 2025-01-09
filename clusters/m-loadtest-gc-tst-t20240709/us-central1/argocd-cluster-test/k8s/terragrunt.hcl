include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "envcommon" {
  path   = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/k8s.hcl"
  expose = true
}

terraform {
  source = "${include.envcommon.locals.base_source_url}?ref=${include.envcommon.locals.version}"
}

locals {
  account_vars          = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  service_account_name  = local.account_vars.locals.service_account
  project_id            = local.account_vars.locals.project_id
  service_account_email = "${local.service_account_name}@${local.project_id}.iam.gserviceaccount.com"
}

inputs = {
  # All configurations here will have precedence over the default
  node_label            = "argocd-cluster-test"
  node_count            = 2
  deletion_protection   = false
  machine_type          = "n1-standard-4"
  service_account_email = "${local.service_account_email}"
}
