include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/k8s.hcl"
  expose = true
}

terraform {
  source = "${include.envcommon.locals.base_source_url}?ref=${include.envcommon.locals.version}"
}

dependency "service_account" {
  config_path = find_in_parent_folders("service_account")
  mock_outputs = {
    sa_email = "sa_email@project_id.iam.google.com"
  }
}

dependency "vpc" {
  config_path = find_in_parent_folders("vpc_default")
  mock_outputs = {
    network_self_link    = "projects/project_id/global/networks/default"
    subnetwork_self_link = "projects/project_id/regions/region/subnetworks/default"
  }
}

inputs = {
  # All configurations here will have precedence over the default
  node_label            = "teste-ci-terragrunt"
  node_count            = 1
  deletion_protection   = false
  machine_type          = "n1-standard-4"
  service_account_email = "${dependency.service_account.outputs.sa_email}"
  network_self_link     = dependency.vpc.outputs.network_self_link
  subnetwork_self_link  = dependency.vpc.outputs.subnetwork_self_link
}
