# Google Cloud Marketplace Terraform Module

This module deploys a product from Google Cloud Marketplace.

## Usage
The provided test configuration can be used by modifying variables in override.tfvars and the bucket in backet.tf and executing:

```
gcloud projects describe "gce-nvidia-olx" --format="value(projectNumber)"

terraform plan --var-file override.tfvars
```

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| project_id | The ID of the project in which to provision resources. | `string` | `null` | yes |
| goog_cm_deployment_name | The name of the deployment and VM instance. | `string` | `null` | yes |
| source_image | The image name for the disk for the VM instance. | `string` | `"projects/nvidia-ngc-public/global/images/nvidia-gpu-cloud-vmi-base-2025-9-1-x86-64"` | no |
| zone | The zone for the solution to be deployed. | `string` | `"us-central1-b"` | no |
| machine_type | The machine type to create, e.g. e2-small | `string` | `"g2-standard-4"` | no |
| boot_disk_type | The boot disk type for the VM instance. | `string` | `"pd-ssd"` | no |
| boot_disk_size | The boot disk size for the VM instance in GBs | `number` | `128` | no |
| networks | The network name to attach the VM instance. | `list(string)` | `["default"]` | no |
| sub_networks | The sub network name to attach the VM instance. | `list(string)` | `[]` | no |
| external_ips | The external IPs assigned to the VM for public access. | `list(string)` | `["EPHEMERAL"]` | no |
| accelerator_type | The accelerator type resource exposed to this instance. E.g. nvidia-tesla-p100. | `string` | `"nvidia-l4"` | no |
| accelerator_count | The number of the guest accelerator cards exposed to this instance. | `number` | `1` | no |
| enable_cloud_api | Allow full access to all of Google Cloud Platform APIs on the VM | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| instance_self_link | Self-link for the compute instance. |
| instance_zone | Zone for the compute instance. |
| instance_machine_type | Machine type for the compute instance. |
| instance_nat_ip | External IP of the compute instance. |
| instance_network | Self-link for the network of the compute instance. |

## Requirements
### Terraform

Be sure you have the correct Terraform version (1.2.0+), you can choose the binary here:

https://releases.hashicorp.com/terraform/

### Configure a Service Account
In order to execute this module you must have a Service Account with the following project roles:

- `roles/compute.admin`
- `roles/iam.serviceAccountUser`

If you are using a shared VPC:

- `roles/compute.networkAdmin` is required on the Shared VPC host project.

### Enable API
In order to operate with the Service Account you must activate the following APIs on the project where the Service Account was created:

- Compute Engine API - `compute.googleapis.com`
