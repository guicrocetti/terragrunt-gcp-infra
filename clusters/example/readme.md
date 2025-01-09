# Project Overview

This is an example template for deploying your infrastructure. To use it, simply copy and paste the folder structure, replacing the name **example** with your `project_id`.

## Region and Clusters

The second nested folder is the **region**. Here, copy and paste the `example-region` folder, replacing its name with the name of your region (e.g., `us_central1`, `europe_west4`, etc.).

Within each region folder, there is a **clusters** folder. Rename each cluster folder following this pattern: **_"cluster-client-environment"_**. For instance: **_"marketplace-shared-prod"_**.

## Resources

Inside the `resources` folder, you can deploy each of your resources in separate subfolders, such as `k8s`, `scylla_cloud`, `loadbalancer`, etc.

### terragrunt.hcl

Each resource folder only requires a single `terragrunt.hcl` file. The basic structure for this file is as follows:

```hcl
# Use "root" to access variables from "env.hcl", "region.hcl", and "account.hcl" in parent folders
include "root" {
  path = find_in_parent_folders("root.hcl")
}

# Use "envcommon" to include common variables defined in the _envcommon folder.
# Ensure resource folder names match those in _envcommon (e.g., _envcommon/k8s.hcl)
include "envcommon" {
  path = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/k8s.hcl"
  expose = true
}

# Define "source" as the module source repository link.
# Ensure the correct naming pattern is used, such as dev/test/prod, matching the cluster name
terraform {
  source = "${include.envcommon.locals.base_source_url}?ref=${include.envcommon.locals.version}"
}

# Custom configurations will override defaults here
inputs = {
  node_label = "my-custom-node-label"
  node_count = 1
}
```

With this template, you can set up your infrastructure with minimal adjustments. Remember to maintain consistent naming conventions throughout the folder structure for clarity and organization.
