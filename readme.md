# Infrastructure Repositories Architecture

This project follows a split repository pattern for better infrastructure management:

## Repository Structure

1. **Terraform Modules Repository[https://github.com/secomind/terraform-modules]**

   - Contains reusable Terraform modules
   - Focuses on modular and maintainable infrastructure components

2. **Terragrunt Infrastructure Repository[https://github.com/secomind/gitops-infra]**
   - Implements infrastructure using Terragrunt
   - References modules from the Terraform repository
   - Requires access to GitHub environments
   - Contains sensitive configuration and organization-specific settings

## Requirements

- GitHub Organization access for environment management
- Enterprise GitHub features for environment protection rules
- Access to private repository features
