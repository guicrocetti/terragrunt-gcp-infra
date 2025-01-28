# include "root" {
#   path = find_in_parent_folders("root.hcl")
# }

# include "envcommon" {
#   path   = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/iam_project_binding.hcl"
#   expose = true
# }

# terraform {
#   source = "${include.envcommon.locals.base_source_url}?ref=${include.envcommon.locals.version}"
# }

# dependency "service_account" {
#   config_path = find_in_parent_folders("service_account")
#   mock_outputs = {
#     sa_email = "sa_email@project_id.iam.google.com"
#     sa_id    = "projects/project-id/serviceAccounts/service-account-name@project-id.iam.gserviceaccount.com"
#   }
# }

# inputs = {
#   roles = [
#     "roles/secretmanager.viewer",
#     "roles/secretmanager.secretAccessor",
#     "roles/container.admin"
#   ]
#   members = [
#     "serviceAccount:${dependency.service_account.outputs.sa_email}"
#   ]
# }
