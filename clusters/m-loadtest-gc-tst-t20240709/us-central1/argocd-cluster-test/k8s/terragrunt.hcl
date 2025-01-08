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

dependency "vpc" {
  config_path = find_in_parent_folders("vpc")
  mock_outputs = {
    network_self_link    = "projects/project_id/global/networks/default"
    subnetwork_self_link = "projects/project_id/regions/region/subnetworks/default"
  }
}

inputs = {
  # All configurations here will have precedence over the default
  node_label            = "argocd-cluster-test"
  node_count            = 3
  deletion_protection   = false
  machine_type          = "n1-standard-8"
  service_account_email = "${local.service_account_email}"
  network_self_link     = dependency.vpc.outputs.network_self_link
  subnetwork_self_link  = dependency.vpc.outputs.subnetwork_self_link
}
