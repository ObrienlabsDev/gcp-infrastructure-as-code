
20260514
see https://docs.cloud.google.com/firewall/docs
terraform https://registry.terraform.io/modules/PaloAltoNetworks/swfw-modules/google/latest/examples/cloud_ngfw

add
https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/network_security_tls_inspection_policy
https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/network_security_gateway_security_policy_rule

# Bootstrap

```
gcloud config set project ngfw-archeytpe-old
gcloud services enable compute.googleapis.com
gcloud services enable networksecurity.googleapis.com
gcloud services enable iam.googleapis.com

```
## Project

# Deployment

Change the GCS bucket in backend.tf
```
terraform init

```