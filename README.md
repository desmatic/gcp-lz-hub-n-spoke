# gcp-lz-hub-n-spoke

### Privileges needed for development

1. Billing Account User (roles/billing.user)
1. Compute Network Admin (roles/compute.networkAdmin)
1. Compute Shared VPC Admin (roles/compute.xpnAdmin)
1. Folder Admin (roles/resourcemanager.folderAdmin)
1. Organization Administrator (roles/resourcemanager.organizationAdmin)
1. Organization Policy Administrator (roles/orgpolicy.policyAdmin)
1. Project Creator (roles/resourcemanager.projectCreator)
1. Project Deleter (roles/resourcemanager.projectDeleter)

### How to deploy to your own landingzone folder using Cloud Shell

You can skip straight to the environment folder for workload development (recommended). You need capacity for 20 new projects to deploy from start to finish. Please note: you can't deploy the organizational groups or billing modules to a folder, so skip them.

#### Pull and configure repo
1. create a landing zone folder and a bootstrap/pipeline project for making API calls
1. cp env.local .env.local
1. vi .env.local
1. source .env.local
1. gcloud config set project ultra-heading-383615
1. configure git and fetch repo

```bash
git config --global user.email "emailaddress"
git config --global user.name "name"
git config --global init.defaultBranch main
gcloud source repos clone gcp-lz-hub-n-spoke --project=ultra-heading-383615
cd gcp-lz-hub-n-spoke
git fetch --all
git checkout main
```

#### Deploy repo using terraform (skip group and billing modules for folder deployments)
1. in numeric order loop through each folder executing terraform init && terraform apply
1. you may need to update and source .env.local with terraform outputs from previous folders (composition)
1. add environment variables to a pipeline to implement your CI/CD of choice for each folder/module
