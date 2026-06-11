#!/bin/bash

# Create directories
mkdir -p \
environments/prod \
environments/staging \
modules/{networking,compute,database,cache,cdn,dns,observability} \
global \
.github/workflows

# Environment files
touch environments/prod/{main.tf,variables.tf,terraform.tfvars,backend.tf,outputs.tf}
touch environments/staging/{main.tf,variables.tf,terraform.tfvars,backend.tf,outputs.tf}

# Module files
touch modules/networking/{main.tf,variables.tf,outputs.tf}

touch modules/compute/{main.tf,variables.tf,outputs.tf}

touch modules/database/{main.tf,replica.tf,variables.tf}

touch modules/cache/main.tf

touch modules/cdn/{main.tf,waf.tf}

touch modules/dns/main.tf

touch modules/observability/{main.tf,dashboard.tf}

# Global files
touch global/{bootstrap.tf,iam_ci.tf}

# GitHub Actions files
touch .github/workflows/{plan.yml,apply.yml}

# Root files
touch .pre-commit-config.yaml README.md

echo "Terraform project structure created successfully."