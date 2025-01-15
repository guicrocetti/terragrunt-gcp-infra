# ---------------------------------------------------------------------------------------------------------------------
# COMMON TERRAGRUNT CONFIGURATION
# This is the common component configuration for IAM PROJECT BINDING.
# ---------------------------------------------------------------------------------------------------------------------

locals {
  # Automatically load environment-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  service_account_name = local.account_vars.locals.service_account
  project_id      = local.account_vars.locals.project_id

  # Automatically load environment-level variables

  # Expose the base's source URL and the module's tag_version separately, so that it can be overwritten if necessary.
  # This will be used to construct the source URL in the child terragrunt configurations.
  version         = local.env_vars.locals.version
  base_source_url = "${get_env("TF_VAR_github_modules_url", "")}//modules/iam_service_account_binding"
  service_account_email = "${local.service_account_name}@${local.project_id}.iam.gserviceaccount.com"
}

# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module. This defines the parameters that are common across all
# environments.
# ---------------------------------------------------------------------------------------------------------------------
inputs = {
  roles   = ["roles/editor", ]
  members = ["serviceAccount:${local.service_account_email}", ]
}
