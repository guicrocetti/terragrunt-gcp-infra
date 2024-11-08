# Set common variables for the environment. This is automatically pulled in in the root terragrunt.hcl configuration to
# feed forward to the child modules.
locals {
  cluster_name = basename(get_parent_terragrunt_dir())
  environment  = regex("(?:.*-)?([^/-]+)$", local.cluster_name_full)
}
