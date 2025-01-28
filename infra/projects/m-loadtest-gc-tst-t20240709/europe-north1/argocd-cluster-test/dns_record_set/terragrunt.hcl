
include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "envcommon" {
  path   = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/dns_record_set.hcl"
  expose = true
}

terraform {
  source = "${include.envcommon.locals.base_source_url}?ref=${include.envcommon.locals.version}"
}

dependency "loadbalancer" {
  config_path = find_in_parent_folders("loadbalancer")
  mock_outputs = {
    loadbalancer_ip = "0.0.0.0"
  }
}

inputs = {
  dns_zone             = "guilherme-iot-basics-com"
  sub_domain           = "argocd"
  dns_name             = "guilherme.iot-basics.com."
  loadbalancer_address = dependency.loadbalancer.outputs.loadbalancer_ip
}
