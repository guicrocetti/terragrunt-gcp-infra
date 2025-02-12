# ---------------------------------------------------------------------------------------------------------------------
# COMMON TERRAGRUNT CONFIGURATION
# This is the common component configuration for cloudAMQP. The common variables for each environment to
# deploy cloudAMQP are defined here. This configuration will be merged into the environment configuration
# via an include block.
# ---------------------------------------------------------------------------------------------------------------------

locals {
  # Automatically load environment-level variables
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Expose the base's source URL and the module's tag_version separately, so that it can be overwritten if necessary.
  # This will be used to construct the source URL in the child terragrunt configurations.
  version         = local.env_vars.locals.version
  base_source_url = "${get_env("TF_VAR_github_modules_url", "")}//modules/cloud_amqp"
}

# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module. This defines the parameters that are common across all
# environments.
# ---------------------------------------------------------------------------------------------------------------------
inputs = {
  cloudamqp_instance_name = "${local.env_vars.locals.cluster_name}-cloudamqp"
  cloudamqp_plan          = "lemur" # "This is the free, smallest instance available. It is not suitable for production environments. Please, make sure you override this setting."
  cloudamqp_apikey        = get_env("TF_VAR_cloudamqp_apikey", "")
  keep_associated_vpc     = false           # To keep the managed VPC when deleting the instance, set attribute keep_associated_vpc to true
  vpc_id                  = ""              # If you want to use an existing CloudAMQP VPC, specify its VPC ID in your terragrunt.hcl file. If you don't set a VPC ID, a new VPC will be created automatically.
  subnet                  = "10.56.72.0/24" # If you don't set a VPC ID, you must specify a subnet for the new VPC.
  tags                    = ["terragrunt", "${local.env_vars.locals.cluster_name}"]
}
