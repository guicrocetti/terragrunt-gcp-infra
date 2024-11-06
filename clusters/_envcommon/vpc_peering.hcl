# ---------------------------------------------------------------------------------------------------------------------
# COMMON TERRAGRUNT CONFIGURATION
# This is the common component configuration for GCLOUD VPC. The common variables for each environment to
# deploy custom network are defined here. This configuration will be merged into the environment configuration
# via an include block.
# ---------------------------------------------------------------------------------------------------------------------

locals {
  # Automatically load environment-level variables
  env_vars     = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  project_id = local.account_vars.locals.project_id
  cluster    = local.env_vars.locals.cluster_name

  # Expose the base's source URL and the module's tag_version separately, so that it can be overwritten if necessary.
  # This will be used to construct the source URL in the child terragrunt configurations.
  version         = local.env_vars.locals.version
  base_source_url = "${get_env("TF_VAR_github_modules_url", "")}//modules/vpc_peering"
}

inputs = {
  peer_network_self_link1 = "https://www.googleapis.com/compute/v1/projects/${project_id}}/global/networks/default"
  peer_network_name_1     = "defualt"
  peer_network_name_2     = "${local.cluster}-network"
  peer_network_self_link2 = "https://www.googleapis.com/compute/v1/projects/${project_id}}/global/networks/${local.cluster}-network"
}
