output "scylladbcloud_cluster_id" {
  value = data.scylladbcloud_cql_auth.scylla_0.cluster_id
}

output "scylladbcloud_cluster_datacenter" {
  value = data.scylladbcloud_cql_auth.scylla_0.datacenter
}

output "scylla_host" {
  value = data.scylladbcloud_cql_auth.scylla_0.seeds
}

output "scylla_password" {
  value     = data.scylladbcloud_cql_auth.scylla_0.password
  sensitive = true
}

output "scylla_user" {
  value     = data.scylladbcloud_cql_auth.scylla_0.username
  sensitive = true
}

output "scylladbcloud_allowlist_rule_id" {
  value = scylladbcloud_allowlist_rule.scylla_0.rule_id
}
