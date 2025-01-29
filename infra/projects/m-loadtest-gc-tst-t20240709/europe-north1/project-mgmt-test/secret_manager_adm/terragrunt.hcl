include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "envcommon" {
  path   = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/secret_manager.hcl"
  expose = true
}

terraform {
  source = "${include.envcommon.locals.base_source_url}?ref=${include.envcommon.locals.version}"
}

dependency "workload_identity" {
  config_path = find_in_parent_folders("iam_workload_id_github_oidc_adm")
  mock_outputs = {
    pool_name     = "workload_identity",
    provider_name = "provider_name",
  }
}

dependency "service_account" {
  config_path = find_in_parent_folders("service_account_adm")
  mock_outputs = {
    sa_email = "sa_email@project_id.iam.google.com"
    sa_id    = "projects/project-id/serviceAccounts/service-account-name@project-id.iam.gserviceaccount.com"
    sa_name  = "service-account-name"
  }
}

inputs = {
  SECRET_DATA = jsonencode({
    "pool_name"     = dependency.workload_identity.outputs.pool_name,
    "provider_name" = dependency.workload_identity.outputs.provider_name,
    "sa_email"      = dependency.service_account.outputs.sa_email,
    "sa_id"         = dependency.service_account.outputs.sa_id,
    "sa_name"       = dependency.service_account.outputs.sa_name,
  })
  secret_name = "github-ci-credentials"
}
