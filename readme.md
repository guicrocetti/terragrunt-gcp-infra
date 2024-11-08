# Infrastructure Repositories Architecture

This project follows a split repository pattern for better infrastructure management:

## Repository Structure

1. **Terraform Modules Repository (Public)**

   - Contains reusable Terraform modules
   - Publicly accessible for community use
   - Focuses on modular and maintainable infrastructure components

2. **Terragrunt Infrastructure Repository (Private)**
   - Implements infrastructure using Terragrunt
   - References modules from the public Terraform repository
   - Requires access to GitHub environments (enterprise features)
   - Contains sensitive configuration and organization-specific settings

## Requirements

- GitHub Organization access for environment management
- Enterprise GitHub features for environment protection rules
- Access to private repository features
