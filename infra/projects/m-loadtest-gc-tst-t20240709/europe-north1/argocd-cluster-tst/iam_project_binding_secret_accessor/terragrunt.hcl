# This Terragrunt configuration sets up IAM project binding for a Secret Manager accessor service account. 
# It includes the common IAM project binding configuration from the `_envcommon/iam_project_binding.hcl` file, 
# and binds the `secretmanager.viewer` and `secretmanager.secretAccessor` roles to the service account defined 
# in the `service_account_argocd_seccret_accessor` dependency.

#TODO: add conditional binding for service account

include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "envcommon" {
  path   = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/iam_project_binding.hcl"
  expose = true
}

terraform {
  source = "${include.envcommon.locals.base_source_url}?ref=${include.envcommon.locals.version}"
}

dependency "service_account" {
  config_path = find_in_parent_folders("service_account_argocd_secret_accessor")
  mock_outputs = {
    sa_email = "sa_email@project_id.iam.google.com"
    sa_id    = "projects/project-id/serviceAccounts/service-account-name@project-id.iam.gserviceaccount.com"
  }
}

inputs = {
  roles = [
    "roles/secretmanager.viewer",
    "roles/secretmanager.secretAccessor"
  ]
  members = [
    "serviceAccount:${dependency.service_account.outputs.sa_email}"
  ]
}
