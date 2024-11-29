

include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/iam_project_member.hcl"
  expose = true
}

terraform {
  source = "${include.envcommon.locals.base_source_url}?ref=${include.envcommon.locals.version}"
}

dependency "service_account" {
  config_path = find_in_parent_folders("service_account")
  mock_outputs = {
    sa_email = "sa_email@project_id.iam.google.com"
  }
}

inputs = {
  roles  = ["roles/secretmanager.secretAccessor"]
  member = "serviceAccount:${dependency.service_account.outputs.sa_email}"
}
