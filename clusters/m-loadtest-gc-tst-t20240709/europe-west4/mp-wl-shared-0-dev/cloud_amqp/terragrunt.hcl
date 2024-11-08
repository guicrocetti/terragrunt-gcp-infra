include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/cloud_amqp_vpc.hcl"
  expose = true
}

terraform {
  source = "${include.envcommon.locals.base_source_url}?ref=${include.envcommon.locals.version}"
}

dependency "vpc" {
  config_path = find_in_parent_folders("default_vpc")
  mock_outputs = {
    network_self_link = "projects/project-id/global/networks/default"
  }
}


inputs = {
  # All configurations here will have precedence over the default
  network_self_link = dependency.vpc.outputs.network_self_link
}
