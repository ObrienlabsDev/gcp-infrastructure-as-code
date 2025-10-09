# gcp-infrastructure-as-code
private version https://github.com/ObrienlabsDev/gcp-infrastructure-as-code-private

# Installation
## gcloud CLI
## Terraform 
Use tfswitch
```
brew install warrensbox/tap/tfswitch
tfswitch 1.13.3

export PATH="$PATH:/Users/mi...n/bin"
```

# Quickstart
## GCP bootstrap project and Service Account

Script

Output
- sa-user-github-cb@gcp-infrastructure-as-code.iam.gserviceaccount.com

## Generate a github legacy token
GCP only recognizes the older tokens

```
clone
cd 1-*
terraform init
vi terraform.tfvars - add PAT
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars

google_secret_manager_secret.github_token_secret: Creating...
google_secret_manager_secret.github_token_secret: Creation complete after 0s [id=projects/gcp-infrastructure-as-code/secrets/github_tf]
google_secret_manager_secret_iam_policy.policy: Creating...
google_secret_manager_secret_version.github_token_secret_version: Creating...
google_secret_manager_secret_iam_policy.policy: Creation complete after 1s [id=projects/gcp-infrastructure-as-code/secrets/github_tf]
google_secret_manager_secret_version.github_token_secret_version: Creation complete after 2s [id=projects/319811514193/secrets/github_tf/versions/1]
google_cloudbuildv2_connection.my_connection: Creating...
google_cloudbuildv2_connection.my_connection: Still creating... [00m10s elapsed]
google_cloudbuildv2_connection.my_connection: Creation complete after 10s [id=projects/gcp-infrastructure-as-code/locations/northamerica-northeast1/connections/github_tf]

Apply complete! Resources: 4 added, 0 changed, 0 destroyed.
```
# References
- for design pattern around Shared VPCs and Project Architecture in a hybrid environment see the official Google Cloud Networking Design Patterns slide deck - https://docs.google.com/presentation/d/1fn9WaATaxnlbW80ykfRJPkLR4FxZ5X0bOOMfaVK9_uc/edit?resourcekey=0-_XJJE6FFw2Y6x49uEzlqZw&slide=id.g1154b3b950f_2_820#slide=id.g1154b3b950f_2_820 off https://cloud.google.com/architecture/blueprints/security-foundations and https://cloud.google.com/architecture/landing-zones/decide-network-design

# Bootstrap Project
# Cloud Build Infrastructure
- https://cloud.google.com/build/docs/terraform
- follow https://cloud.google.com/build/docs/automating-builds/github/connect-repo-github?generation=2nd-gen#terraform
- Install Cloud Build connector on Github
- <img width="1088" height="1492" alt="image" src="https://github.com/user-attachments/assets/e3c836ef-425b-41ce-a437-dc062d0a133c" />
- <img width="1488" height="1462" alt="image" src="https://github.com/user-attachments/assets/7a6c4d45-835a-484e-a438-36e0b3d3b3a2" />
- generate PAT with code read permissions
- create a bootstrap project
- set billing on the project, check project owner
- in a cloud shell

```
gcloud config set project gcp-infrastructure-as-code
el@cloudshell:~/gcp-infrastructure-as-code/1-cloud-build (gcp-infrastructure-as-code)$
// reuse bootstrap for now
git clone https://github.com/ObrienlabsDev/gcp-infrastructure-as-code.git
cd gcp-infrastructure-as-code/
cd 1-cloud-build/
```
## Enable select google APIs
```
gcloud services enable secretmanager.googleapis.com
gcloud services enable cloudbuild.googleapis.com
# for cloud sql
gcloud services enable compute.googleapis.com
gcloud services enable sqladmin.googleapis.com

```
## Terraform apply
```
terraform init
terraform plan -var-file=terraform.tfvars

terraform 1.5.7

Terraform will perform the following actions:


  # google_cloudbuildv2_connection.my_connection will be created
  + resource "google_cloudbuildv2_connection" "my_connection" {
      + create_time           = (known after apply)
      + effective_annotations = (known after apply)
      + etag                  = (known after apply)
      + id                    = (known after apply)
      + installation_state    = (known after apply)
      + location              = "northamerica-northeast1"
      + name                  = "github"
      + project               = "gcp-infrastructure-as-code"
      + reconciling           = (known after apply)
      + update_time           = (known after apply)

      + github_config {
          + app_installation_id = 88877838

          + authorizer_credential {
              + oauth_token_secret_version = (known after apply)
              + username                   = (known after apply)
            }
        }
    }

  # google_secret_manager_secret.github_token_secret will be created
  + resource "google_secret_manager_secret" "github_token_secret" {
      + create_time           = (known after apply)
      + deletion_protection   = false
      + effective_annotations = (known after apply)
      + effective_labels      = {
          + "goog-terraform-provisioned" = "true"
        }
      + expire_time           = (known after apply)
      + id                    = (known after apply)
      + name                  = (known after apply)
      + project               = "gcp-infrastructure-as-code"
      + secret_id             = "github"
      + terraform_labels      = {
          + "goog-terraform-provisioned" = "true"
        }

      + replication {
          + auto {
            }
        }
    }

  # google_secret_manager_secret_iam_policy.policy will be created
  + resource "google_secret_manager_secret_iam_policy" "policy" {
      + etag        = (known after apply)
      + id          = (known after apply)
      + policy_data = jsonencode(
            {
              + bindings = [
                  + {
                      + members = [
                          + "serviceAccount:service-319811514193@gcp-sa-cloudbuild.iam.gserviceaccount.com",
                        ]
                      + role    = "roles/secretmanager.secretAccessor"
                    },
                ]
            }
        )
      + project     = "gcp-infrastructure-as-code"
      + secret_id   = "github"
    }

  # google_secret_manager_secret_version.github_token_secret_version will be created
  + resource "google_secret_manager_secret_version" "github_token_secret_version" {
      + create_time            = (known after apply)
      + deletion_policy        = "DELETE"
      + destroy_time           = (known after apply)
      + enabled                = true
      + id                     = (known after apply)
      + is_secret_data_base64  = false
      + name                   = (known after apply)
      + secret                 = (known after apply)
      + secret_data            = (sensitive value)
      + secret_data_wo_version = 0
      + version                = (known after apply)
    }

Plan: 4 to add, 0 to change, 0 to destroy.
```

## Troubleshooting
### Expected SA creation
```
│ Error: Error setting IAM policy for secretmanager secret "projects/gcp-infrastructure-as-code/secrets/github": googleapi: Error 400: Service account service-319811514193@gcp-sa-cloudbuild.iam.gserviceaccount.com does not exist.
```
- connect to github account first - this will automatically create the service account
- https://cloud.google.com/build/docs/automating-builds/github/connect-repo-github?generation=2nd-gen#connect_to_a_github_host

```
gcloud services enable cloudbuild.googleapis.com
```
<img width="2226" height="1030" alt="image" src="https://github.com/user-attachments/assets/eb5537e8-ab09-4efc-b967-67f681e4cc0f" />

### Change the ids - plan/apply
```
Plan: 4 to add, 0 to change, 3 to destroy.

google_secret_manager_secret_iam_policy.policy: Destroying... [id=projects/gcp-infrastructure-as-code/secrets/github]
google_secret_manager_secret_version.github_token_secret_version: Destroying... [id=projects/319811514193/secrets/github/versions/1]
google_secret_manager_secret_version.github_token_secret_version: Destruction complete after 0s
google_secret_manager_secret_iam_policy.policy: Destruction complete after 0s
google_secret_manager_secret.github_token_secret: Destroying... [id=projects/gcp-infrastructure-as-code/secrets/github]
google_secret_manager_secret.github_token_secret: Destruction complete after 1s
google_secret_manager_secret.github_token_secret: Creating...
google_secret_manager_secret.github_token_secret: Creation complete after 1s [id=projects/gcp-infrastructure-as-code/secrets/github_tf]
google_secret_manager_secret_iam_policy.policy: Creating...
google_secret_manager_secret_version.github_token_secret_version: Creating...
google_secret_manager_secret_iam_policy.policy: Creation complete after 0s [id=projects/gcp-infrastructure-as-code/secrets/github_tf]
google_secret_manager_secret_version.github_token_secret_version: Creation complete after 1s [id=projects/319811514193/secrets/github_tf/versions/1]
google_cloudbuildv2_connection.my_connection: Creating...
google_cloudbuildv2_connection.my_connection: Still creating... [10s elapsed]
╷
│ Error: Error waiting to create Connection: Error waiting for Creating Connection: Error code 9, message: failed to get authenticated user from GitHub: GET https://api.github.com/user: 401 Bad credentials []
│ 
│   with google_cloudbuildv2_connection.my_connection,
│   on main.tf line 39, in resource "google_cloudbuildv2_connection" "my_connection":
│   39: resource "google_cloudbuildv2_connection" "my_connection" {

regenerated token (auto-expired) - moved to 366 days
│ Error: Error waiting to create Connection: Error waiting for Creating Connection: Error code 9, message: the user token does not have access to installations (if using a personal access token, make sure it has enough permissions)

```
forgot org permissions
checked https://github.com/organizations/ObrienlabsDev/settings/personal-access-tokens


# User IAM permissions
# Service Account Creation
# Service Account IAM permissions
# Shared VPC Host Project Creation
# Shared VPC Services Project Creation
## Service Account for Services Project
## Workload Identity Federation
## CloudSQL Database
## Database Creation
## Private Service Connect endpoints


# Triage
## PAT Limitations
- https://issuetracker.google.com/issues/343223837?pli=1
- 
