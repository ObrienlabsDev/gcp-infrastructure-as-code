# Google Cloud Marketplace Terraform Module

This module deploys a product from Google Cloud Marketplace.

## Usage
The provided test configuration can be used by modifying variables in override.tfvars and the bucket in backet.tf and executing:

```
gcloud projects describe "gce-nvidia-olx" --format="value(projectNumber)"
gcloud storage buckets create gs://ops-cicd-olx --project=ops-cicd-olx --location=northamerica-northeast1
```

## Terraform apply

```
terraform init
terraform validate
terraform plan -var-file override.tfvars
terraform apply -var-file override.tfvars -auto-approve

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
Outputs:
instance_machine_type = "g2-standard-4"
instance_nat_ip = "35.227.112.39"
instance_network = "default"
instance_self_link = "https://www.googleapis.com/compute/v1/projects/gce-nvidia-olx/zones/us-east1-c/instances/test-deployment-vm"
instance_zone = "us-east1-c"
```

## SSH to VM

```
michael@cloudshell:~/wse_github/gcp-infrastructure-as-code/m10-3rdparty/m11-nvidia-gce-terraform-ubuntu (ops-cicd-olx)$ gcloud compute ssh test-deployment-vm --zone=us-east1-c --project=gce-nvidia-olx
Updating project ssh metadata...workingUpdated [https://www.googleapis.com/compute/v1/projects/gce-nvidia-olx].                                                                                                                                                

The following GCP CLI version has been pre-installed. Begin using the GCP CLI by first configuring your credentials using 'gcloud init'
Google Cloud SDK 541.0.0
Welcome to the NVIDIA GPU Cloud image.  This image provides an optimized
environment for running the deep learning and HPC containers from the
NVIDIA GPU Cloud Container Registry.  
michael@test-deployment-vm:~$ nvidia-smi
Mon Jan 19 00:50:38 2026       
+-----------------------------------------------------------------------------------------+
| NVIDIA-SMI 570.172.08             Driver Version: 570.172.08     CUDA Version: 12.8     |
|-----------------------------------------+------------------------+----------------------+
| GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |
| Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
|                                         |                        |               MIG M. |
|=========================================+========================+======================|
|   0  NVIDIA L4                      On  |   00000000:00:03.0 Off |                    0 |
| N/A   29C    P8             11W /   72W |       0MiB /  23034MiB |      0%      Default |
|                                         |                        |                  N/A |
+-----------------------------------------+------------------------+----------------------+                                                                                  
michael@test-deployment-vm:~$ exit

## Terraform destroy

```
terraform destroy -var-file override.tfvars -auto-approve
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
