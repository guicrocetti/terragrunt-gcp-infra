# Project-Level IAM Management Guide
This directory manages centralized role assignments and permissions at the project level, including the creation of management service accounts.

## Project-Level Permissions Example
The following example demonstrates how to configure project-wide IAM bindings and, optionally, restrict permissions to resources that have specific tags.

```
include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "envcommon" {
  path = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/iam_project_binding.hcl"
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
  roles = [
    "roles/secretmanager.secretAccessor",
    "roles/iam.workloadIdentityUser",
    "roles/resourcemanager.projectIamAdmin",
    "roles/iam.serviceAccountTokenCreator",
    "roles/iam.serviceAccountAdmin",
    "roles/container.admin",
    "roles/multiclusteringress.serviceAgent",
    "roles/dns.admin",
    "roles/clouddeploymentmanager.serviceAgent",
    "roles/backupdr.cloudStorageOperator"
  ]
  members = ["serviceAccount:${dependency.service_account.outputs.sa_email}"]
}
```

Optional: Add a condition to restrict permissions based on resource tags.

In this example, the binding only applies if the accessed resource has a tag
"environment" with the value "prod".

```
condition = {
    title       = "restrict_by_tag"
    description = "Allow access only if tag 'environment' is 'prod"
    expression  = " resource.matchTag(' environment ', ' prod ') "
  }
```

## Important Note on Permission Management
Permissions defined at this project level take precedence over service account-specific permissions. 
When you configure any of the roles listed above for other service accounts, the project-level 
permissions will override them. This centralized approach ensures consistent permission management 
and prevents unintended permission escalation through service account-specific assignments.

Using IAM Conditions with tag-based restrictions, as shown above, allows you to enforce that a binding only applies when the target resource carries the expected tags. For further details on writing condition expressions and using tags for access control, please refer to [Google Cloud IAM Tags Access Control](https://cloud.google.com/iam/docs/tags-access-control).
