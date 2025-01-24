# Authoritative for a given role. Updates the IAM policy to grant a role to a list of members. 
# Other roles within the IAM policy for the service account are preserved.

# Controls ALL permissions for a specific role on a service account
# Replaces entire list of members when you make changes
# Use when you want to strictly control who can use/manage a service account
# Example: "Only these 3 teams can act as this service account"

include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "envcommon" {
  path   = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/iam_service_account_binding.hcl"
  expose = true
}

terraform {
  source = "${include.envcommon.locals.base_source_url}?ref=${include.envcommon.locals.version}"
}

locals {
  account_vars           = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  workload_identity_pool = "${local.account_vars.locals.project_id}.svc.id.goog"
}

dependency "service_account" {
  config_path = find_in_parent_folders("service_account")
  mock_outputs = {
    sa_email = "sa_email@project_id.iam.google.com"
    sa_id    = "projects/project-id/serviceAccounts/service-account-name@project-id.iam.gserviceaccount.com"
  }
}

dependency "argocd" {
  config_path = find_in_parent_folders("argocd")
  mock_outputs = {
    sa_name      = "es-sa"
    sa_namespace = "es-namespace"
  }
}

inputs = {
  service_account_id = dependency.service_account.outputs.sa_id
  roles              = ["roles/iam.workloadIdentityUser"]
  members = [
    "serviceAccount:${local.workload_identity_pool}[${dependency.argocd.outputs.sa_namespace}/${dependency.argocd.outputs.sa_name}]",
    "serviceAccount:${local.workload_identity_pool}[argocd/argocd-server]",
    "serviceAccount:${local.workload_identity_pool}[argocd/argocd-application-controller]",
  ]
}
