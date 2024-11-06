include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/scylla_cloud.hcl"
  expose = true
}

terraform {
  source = "${include.envcommon.locals.base_source_url}?ref=${include.envcommon.locals.version}"
}

dependency "vpc" {
  config_path = find_in_parent_folders("default_vpc")
  mock_outputs = {
    network_self_link   = "projects/project-id/global/networks/default"
    network_name        = "default"
    network_cidr_ranges = ["mock_ip_ranges"]
    ip_cidr_range       = "mock_ip_range"
  }
}

inputs = {
  # All configurations here will have precedence over the default
  network_self_link   = dependency.vpc.outputs.network_self_link
  network_name        = dependency.vpc.outputs.network_name
  network_cidr_ranges = dependency.vpc.outputs.network_cidr_ranges
  ip_cidr_range       = dependency.vpc.outputs.ip_cidr_range
}
