# ENV

```
export PROJECT_ID=mind-devops-test
export INFRA_REPOSITORY=secomind/terragrunt-infra-test
export SERVICE_ACCOUNT_NAME=github-ci-terragrunt
export WL_POOL_NAME=github-ci-terragrunt
export WL_POOL_PROVIDER_NAME=github-ci-provider
```

# GCLOUD CONFIGS

## Set up workload identity pool

```
gcloud iam workload-identity-pools create $WL_POOL_NAME --location="global" --display-name="Github CI Terragrunt"

gcloud iam workload-identity-pools providers create-oidc $WL_POOL_PROVIDER_NAME --location="global" --workload-identity-pool="$WL_POOL_NAME" --issuer-uri="https://token.actions.githubusercontent.com" --attribute-mapping="google.subject=assertion.sub,attribute.repository=assertion.repository" --attribute-condition="assertion.repository=='$INFRA_REPOSITORY'"

gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME \
 --description="Github CI Terragrunt SA" \
 --display-name="Github CI Terragrunt"
```

## Get Values

```
WL_ID_POOL=$(gcloud iam workload-identity-pools list --location global --format 'json' | jq -r '.[-1].name')
WL_ID_PROVIDER=$(gcloud iam workload-identity-pools providers list --workload-identity-pool=$WL_POOL_NAME  --location global --format 'json' | jq -r '.[-1] | .name')
SA_EMAIL=$(gcloud iam service-accounts list --filter="Github CI Terragrunt" --format="get(email)")
```

## Permissions Needed:

```
gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:$SA_EMAIL" --role="roles/storage.admin" ## Needed for terraform to create buckets

gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:$SA_EMAIL" --role="roles/compute.admin" ## Needed for terraform to create networks

gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:$SA_EMAIL" --role="roles/container.admin" ## Needed for terraform to create clusters

gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:$SA_EMAIL" --role="roles/iam.serviceAccountUser" ## Needed for terraform to create service accounts

gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:$SA_EMAIL" --role="roles/secretmanager.admin" ## Needed for terraform to create secrets


gcloud iam service-accounts add-iam-policy-binding $SA_EMAIL --role="roles/iam.workloadIdentityUser" --member="principalSet://iam.googleapis.com/$WL_ID_POOL/attribute.repository/$INFRA_REPOSITORY"
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

- WORKLOAD_IDENTITY_PROVIDER=$WL_ID_PROVIDER
- SERVICE_ACCOUNT=$SA_EMAIL
- CLOUDAMQP_APIKEY=<CLOUDAMQP_APIKEY>
- SCYLLA_TOKEN=<SCYLLA_TOKEN>

### Variables:

- PROJECT_ID=$PROJECT_ID
- MODULES_URL=git::https://github.com/<user_name>/<repo_name>.git

# SUMMARY:

Here's a clear summary of how users can deploy their clusters (test, dev, prod) based on the provided documentation:

1. Infrastructure Setup:

- The team can fallow the clusters/example folder to create the infrastructure.
- The dev team can deploy clusters only on the dev environment.
- The Ops team can deploy clusters in test and prod environments.
- Name clusters following the pattern: "cluster-client-environment" (e.g., marketplace-shared-prod)
