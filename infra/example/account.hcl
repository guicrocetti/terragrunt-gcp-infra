# Set account-wide variables. These are automatically pulled in to configure the remote state bucket in the root
# terragrunt.hcl configuration.
locals {
  service_account = "${basename(get_parent_terragrunt_dir())}-sa"
  project_id      = basename(get_parent_terragrunt_dir())
}
