include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "envcommon" {
  path   = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/vpc_peering.hcl"
  expose = true
}

terraform {
  source = "${include.envcommon.locals.base_source_url}?ref=${include.envcommon.locals.version}"
}

dependency "vpc1" {
  config_path = find_in_parent_folders("vpc")
  mock_outputs = {
    network_self_link = "projects/m-int-devops-test-t/global/networks/argocd"
    network_name      = "default"
  }
}

dependency "vpc2" {
  config_path = find_in_parent_folders("vpc_default")
  mock_outputs = {
    network_self_link = "projects/m-int-devops-test-t/global/networks/default"
    network_name      = "default"
  }
}


inputs = {
  peer_network_self_link1 = dependency.vpc1.outputs.network_self_link
  peer_network_self_link2 = dependency.vpc2.outputs.network_self_link
  peer_network_name_1     = dependency.vpc1.outputs.network_name
  peer_network_name_2     = dependency.vpc2.outputs.network_name
}
