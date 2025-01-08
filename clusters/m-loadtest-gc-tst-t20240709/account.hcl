# Set account-wide variables. These are automatically pulled in to configure the remote state bucket in the root
# terragrunt.hcl configuration.
locals {
  service_account = "${basename(get_parent_terragrunt_dir())}-tg" # must be between 6 and 30 characters long in total.
  project_id      = basename(get_parent_terragrunt_dir())
}
