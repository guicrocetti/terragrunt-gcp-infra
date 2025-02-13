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

dependency "service_account" {
  config_path = find_in_parent_folders("service_account")
  mock_outputs = {
    sa_email = "sa_email@project_id.iam.google.com"
  }
}

dependency "vpc_default" {
  config_path = find_in_parent_folders("vpc_default")
  mock_outputs = {
    ip_cidr_range = "10.10.0.0/16"
  }
}

inputs = {
  # All configurations here will have precedence over the default
  node_label            = "devops-test-wrkld-0"
  node_count            = 2
  deletion_protection   = false
  machine_type          = "n1-standard-4"
  service_account_email = dependency.service_account.outputs.sa_email
  cluster_name          = "devops-test-wrkld-0"
  ip_cidr_range         = dependency.vpc_default.outputs.ip_cidr_range
}
