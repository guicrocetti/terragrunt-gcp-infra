## GITHUB CONFIGS:

## GCLOUD CONFIGS

```bash
gcloud iam workload-identity-pools create "github-ci-terraform" \
 --project="m-loadtest-gc-tst-t20240709" \
 --location="global" \
 --display-name="Terragrunt wl-Pool"

gcloud iam workload-identity-pools providers create-oidc github-ci-provider \
 --location="global" \
 --workload-identity-pool="github-ci-terraform" \
 --display-name="GitHub workload pool provider" \
 --description="Terragrunt github workload pool provider" \
 --issuer-uri="https://token.actions.githubusercontent.com/" \
 --attribute-mapping="google.subject=assertion.sub,attribute.repository=assertion.repository" \
 --attribute-condition="attribute.repository==assertion.repository" \
 --project m-loadtest-gc-tst-t20240709

gcloud iam service-accounts create github-ci-terragrunt \
 --description="Github CI Terragrunt SA" \
 --display-name="Github CI"

#gcloud iam service-accounts add-iam-policy-binding github-ci-terragrunt@m-loadtest-gc-tst-t20240709.iam.gserviceaccount.com \
# --role=roles/iam.workloadIdentityUser \
# --member="principal://iam.googleapis.com/projects/147253475043/locations/global/workloadIdentityPools/github-ci-terraform/subject/repo:guicrocetti/argocd_deployment_test:pull_request"

gcloud iam service-accounts add-iam-policy-binding github-ci-terragrunt@m-loadtest-gc-tst-t20240709.iam.gserviceaccount.com \
 --role=roles/iam.workloadIdentityUser \
 --member="principal://iam.googleapis.com/projects/147253475043/locations/global/workloadIdentityPools/github-ci-terraform/subject/repo:guicrocetti/argocd_deployment_test"

#gcloud iam service-accounts add-iam-policy-binding github-ci-terragrunt@m-loadtest-gc-tst-t20240709.iam.gserviceaccount.com \
# --role=roles/iam.workloadIdentityUser \
# --member="principalSet://iam.googleapis.com/projects/147253475043/locations/global/workloadIdentityPools/github-ci-terraform/attribute.repository/guicrocetti/argocd_deployment_test"

gcloud projects add-iam-policy-binding m-loadtest-gc-tst-t20240709 --member=serviceAccount:github-ci-terragrunt@m-loadtest-gc-tst-t20240709.iam.gserviceaccount.com --role='roles/storage.admin'

gcloud projects add-iam-policy-binding m-loadtest-gc-tst-t20240709 --member=serviceAccount:github-ci-terragrunt@m-loadtest-gc-tst-t20240709.iam.gserviceaccount.com --role='roles/compute.admin'
```
