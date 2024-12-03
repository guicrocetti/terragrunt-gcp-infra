# Set the project ID for the current environment
export PROJECT_ID="m-int-devops-test-t" # Set to your project ID
export SERVICE_ACCOUNT="github-ci-terragrunt@m-int-devops-test-t.iam.gserviceaccount.com"

# Create the Service Account
gcloud iam service-accounts create github-ci-terragrunt \
  --description="Github CI Terragrunt SA" \
  --display-name="Github CI Terragrunt" \
  --project=$PROJECT_ID

# Create the Workload Identity Pool
gcloud iam workload-identity-pools create github-ci-terragrunt \
  --location="global" \
  --display-name="Github CI Terragrunt" \
  --project=$PROJECT_ID

# Create the OIDC Provider for the Workload Identity Pool
gcloud iam workload-identity-pools providers create-oidc github-ci-provider \
  --location="global" \
  --workload-identity-pool="github-ci-terragrunt" \
  --issuer-uri="https://token.actions.githubusercontent.com" \
  --attribute-mapping="google.subject=assertion.sub,attribute.repository=assertion.repository" \
  --attribute-condition="assertion.repository=='secomind/terragrunt-infra-test'" \
  --project=$PROJECT_ID

# Capture the Workload Identity Pool name
export WL_POOL=$(gcloud iam workload-identity-pools list --location global --format "get(name)" --project=$PROJECT_ID | head -n 1)

# Capture the Workload Identity Provider name
export WL_PROVIDER=$(gcloud iam workload-identity-pools providers list \
  --workload-identity-pool=github-ci-terragrunt \
  --location global \
  --format "get(name)" \
  --project=$PROJECT_ID | head -n 1)

# Grant IAM policy to the Service Account
gcloud iam service-accounts add-iam-policy-binding github-ci-terragrunt@$PROJECT_ID.iam.gserviceaccount.com \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/$WL_POOL/attribute.repository/secomind/terragrunt-infra-test" \
  --project=$PROJECT_ID

gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:$SERVICE_ACCOUNT" --role="roles/multiclusteringress.serviceAgent"

gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:$SERVICE_ACCOUNT" --role="roles/resourcemanager.projectIamAdmin"

gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:$SERVICE_ACCOUNT" --role="roles/iam.workloadIdentityUser"

gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:$SERVICE_ACCOUNT" --role="roles/clouddeploymentmanager.serviceAgent"

echo "Update those values into your GitHub repo's Environment settings:"
echo "Service Account: $SERVICE_ACCOUNT"
echo "Workload Identity Provider: $WL_PROVIDER"
echo "Project ID: $PROJECT_ID"
