# This Terragrunt configuration sets up an IAM project binding for the ArgoCD management service account. 
# It includes the common IAM project binding configuration from the `_envcommon/iam_project_binding.hcl` file, 
# and sets the `roles` and `members` inputs for the IAM project binding.

# The `roles` input specifies the IAM roles to be granted to the service account, in this case the `container.admin` role. 
# The `members` input specifies the service account email to be granted the roles, which is retrieved from the `service_account_argocd_mgmt` dependency.

# TODO: add conditional binding for service account

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
  config_path = find_in_parent_folders("service_account_argocd_mgmt")
  mock_outputs = {
    sa_email = "sa_email@project_id.iam.google.com"
    sa_id    = "projects/project-id/serviceAccounts/service-account-name@project-id.iam.gserviceaccount.com"
  }
}

inputs = {
  roles = [
    "roles/container.admin"
  ]
  members = [
    "serviceAccount:${dependency.service_account.outputs.sa_email}"
  ]
}
