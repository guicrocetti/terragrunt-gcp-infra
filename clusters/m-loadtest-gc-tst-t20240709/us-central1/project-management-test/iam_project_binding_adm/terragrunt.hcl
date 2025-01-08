
# Authoritative for a given role. Updates the IAM policy to grant a role to a list of members. 
# Other roles within the IAM policy for the project are preserved.
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
  config_path = find_in_parent_folders("service_account_adm")
  mock_outputs = {
    sa_email = "sa_email@project_id.iam.google.com"
  }
}

inputs = {
  roles   = ["roles/secretmanager.secretAccessor"]
  members = ["serviceAccount:${dependency.service_account.outputs.sa_email}"]
}
