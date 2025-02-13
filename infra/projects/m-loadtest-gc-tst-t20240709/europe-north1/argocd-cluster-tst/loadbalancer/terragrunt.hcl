# This Terragrunt configuration file is used to manage the loadbalancer 
# infrastructure for the m-int-devops-mgmt-prd project in the europe-north1 region.

include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "envcommon" {
  path   = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/loadbalancer.hcl"
  expose = true
}

terraform {
  source = "${include.envcommon.locals.base_source_url}?ref=${include.envcommon.locals.version}"
}
