# Set common variables for the environment. This is automatically pulled in in the root terragrunt.hcl configuration to
# feed forward to the child modules.
locals {
  cluster_name = basename(get_parent_terragrunt_dir())
  env          = regex("(?:.*-)?([^/-]+)$", local.cluster_name)[0]

  version_config = read_terragrunt_config(find_in_parent_folders("versions.hcl"))
  version        = local.version_config.locals.versions[local.env]
}
