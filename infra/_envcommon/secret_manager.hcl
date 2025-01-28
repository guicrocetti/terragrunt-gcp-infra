# ---------------------------------------------------------------------------------------------------------------------
# COMMON TERRAGRUNT CONFIGURATION
# This is the common component configuration for Google Secret Manager. The common variables for each environment to
# deploy a secret manager are defined here. This configuration will be merged into the environment configuration
# via an include block.
# ---------------------------------------------------------------------------------------------------------------------

locals {
  # Automatically load environment-level variables
  env_vars     = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  cluster     = local.env_vars.locals.cluster_name
  environment = local.env_vars.locals.env
  project_id  = local.account_vars.locals.project_id

  # Expose the base's source URL and the module's tag_version separately, so that it can be overwritten if necessary.
  # This will be used to construct the source URL in the child terragrunt configurations.
  version         = local.env_vars.locals.version
  base_source_url = "${get_env("TF_VAR_github_modules_url", "")}//modules/secret_manager"
}
# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module. This defines the parameters that are common across all
# environments.
# ---------------------------------------------------------------------------------------------------------------------
inputs = {
  labels = {
    Environment = local.environment,
    Service     = local.cluster,
  }
  secret_name     = "${local.project_id}-${local.cluster}-${local.environment}"
  SECRET_DATA     = ""
  cluster_ca_data = ""
  cluster_server  = ""
}
