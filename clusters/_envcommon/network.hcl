# ---------------------------------------------------------------------------------------------------------------------
# COMMON TERRAGRUNT CONFIGURATION
# This is the common component configuration for GCLOUD VPC. The common variables for each environment to
# deploy custom network are defined here. This configuration will be merged into the environment configuration
# via an include block.
# ---------------------------------------------------------------------------------------------------------------------

locals {
  # Automatically load environment-level variables
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  cluster = local.env_vars.locals.cluster_name

  # Expose the base's source URL and the module's tag_version separately, so that it can be overwritten if necessary.
  # This will be used to construct the source URL in the child terragrunt configurations.
  version         = local.env_vars.locals.version
  base_source_url = "${get_env("TF_VAR_github_modules_url", "")}//modules/network"
}

# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module. This defines the parameters that are common across all
# environments.
# ---------------------------------------------------------------------------------------------------------------------
inputs = {
  network_name    = "${local.cluster}-network"
  subnetwork_name = "${local.cluster}-subnetwork"
}
