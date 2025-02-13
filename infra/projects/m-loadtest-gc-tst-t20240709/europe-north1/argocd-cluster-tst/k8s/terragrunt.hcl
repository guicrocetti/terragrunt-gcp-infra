/*
This Terragrunt configuration sets up an ArgoCD cluster in the "europe-north1" region.It includes the following configurations :

-Imports the "root" and "envcommon" configurations from parent folders.
-Sets the Terraform source to a specific version and URL.
-Defines a dependency on a service account, which is used to set the service account email for the cluster.
-Configures the cluster with the following settings :
-Node label : "argocd-cluster-tst"
-Node count : 2
-Deletion protection : enabled
-Machine type : "n1-standard-4"
-Service account email : from the "service_account" dependency
-Cluster name : "argocd-mgmt-prod"
*/

include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "envcommon" {
  path   = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/k8s.hcl"
  expose = true
}

terraform {
  source = "${include.envcommon.locals.base_source_url}?ref=${include.envcommon.locals.version}"
}

dependency "service_account" {
  config_path = find_in_parent_folders("service_account_argocd_mgmt")
  mock_outputs = {
    sa_email = "sa_email@project_id.iam.google.com"
  }
}

dependency "vpc_default" {
  config_path = find_in_parent_folders("vpc_default")
  mock_outputs = {
    ip_cidr_range = "10.10.0.0/16"
  }
}

inputs = {
  # All configurations here will have precedence over the default
  node_label            = "prod"
  node_count            = 2
  deletion_protection   = false
  machine_type          = "n2-standard-4"
  service_account_email = dependency.service_account.outputs.sa_email
  cluster_name          = "argocd-mgmt-prod"
  cidr_blocks = [
    {
      ip_cidr_range = dependency.vpc_default.outputs.ip_cidr_range
      display_name  = "internal"
    },
    {
      ip_cidr_range = "91.193.55.19/32"
      display_name  = "secomind"
    }
  ]
}
