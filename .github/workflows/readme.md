# GCLOUD CONFIGS

## Set up workload identity pool

```
gcloud iam workload-identity-pools create github-ci-terragrunt --location="global" --display-name="Github CI Terragrunt"

gcloud iam workload-identity-pools providers create-oidc github-ci-provider --location="global" --workload-identity-pool="github-ci-terragrunt" --issuer-uri="https://token.actions.githubusercontent.com" --attribute-mapping="google.subject=assertion.sub,attribute.repository=assertion.repository" --attribute-condition="assertion.repository=='<github_username>/<github_repository>'"

gcloud iam service-accounts create github-ci-terragrunt \
 --description="Github CI Terragrunt SA" \
 --display-name="Github CI Terragrunt"
```

## Permissions Needed:

```
gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:$SA_EMAIL" --role="roles/storage.admin" ## Needed for terraform to create buckets

gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:$SA_EMAIL" --role="roles/compute.admin" ## Needed for terraform to create networks

gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:$SA_EMAIL" --role="roles/container.admin" ## Needed for terraform to create clusters

gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:$SA_EMAIL" --role="roles/iam.serviceAccountUser" ## Needed for terraform to create service accounts

gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:$SA_EMAIL" --role="roles/secretmanager.admin" ## Needed for terraform to create secrets


gcloud iam service-accounts add-iam-policy-binding github-ci-terragrunt@<PROJECT_ID>.iam.gserviceaccount.com --role="roles/iam.workloadIdentityUser" --member="principalSet://iam.googleapis.com/projects/147253475043/locations/global/workloadIdentityPools/github-ci-terragrunt/attribute.repository/<github_username>/<github_repository>"
```

# GITHUB CONFIGS:

## Environments:

On prepository go to settings -> Environments:

- Configure 3 environments with different protection rules:
  - dev: no restrictions
  - test: 1 reviewer, test branch only
  - prod: 2 reviewers, main branch only

Secrets and Variables must be configured for each environment.

### Secrets:

WORKLOAD_IDENTITY_PROVIDER=projects/<PROJECT_ID_NUMBER>/locations/global/workloadIdentityPools/github-ci-terragrunt/providers/github-ci-provider
SERVICE_ACCOUNT=<SA_NAME>@<PROJECT_ID>.iam.gserviceaccount.com
CLOUDAMQP_APIKEY=<CLOUDAMQP_APIKEY>
SCYLLA_TOKEN=<SCYLLA_TOKEN>

### Variables:

PROJECT_ID=<PROJECT_ID>
MODULES_URL=git::https://github.com/<user_name>/<repo_name>.git

# SUMMARY:

Here's a clear summary of how users can deploy their clusters (test, dev, prod) based on the provided documentation:

1. Infrastructure Setup:

- The team can fallow the clusters/example folder to create the infrastructure.
- The dev team can deploy clusters only on the dev environment.
- The Ops team can deploy clusters in test and prod environments.
- Name clusters following the pattern: "cluster-client-environment" (e.g., marketplace-shared-prod)
