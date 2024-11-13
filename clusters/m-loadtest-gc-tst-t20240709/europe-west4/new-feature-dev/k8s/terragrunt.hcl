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


inputs = {
  # All configurations here will have precedence over the default
  node_label      = "terragrunt-ci-deployment"
  node_count      = 1
  service_account = "cluster-teste-ci"
}
