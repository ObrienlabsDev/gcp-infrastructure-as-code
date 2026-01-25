# GCE VM with 1 or more L4 GPUs, NVIDIA DL image and associated GCP project/VPC

GPT-OSS:20b Tokens/sec for various M series and NVidia Ampere, Ada and Grace Blackwell GPUs

20260120 - https://github.com/ObrienlabsDev/blog/issues/160 and https://github.com/ObrienlabsDev/gcp-infrastructure-as-code/tree/main/m10-3rdparty/m11-nvidia-gce-terraform-ubuntu

<img width="843" height="516" alt="Image" src="https://github.com/user-attachments/assets/8d20f266-5cc0-4bf0-8145-e9a1e9e13da1" />

## Usage
Modify the variables in override.tfvars and create/edit the bucket in backet.tf first.

```
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
```
## Terraform destroy

```
terraform destroy -var-file override.tfvars -auto-approve
```

## Troubleshooting
### Insufficient Quota on GPUS_ALL_REGIONS
Each GCP project manages it's own quota - while this is ok for predefined or static projects - for generated projects like we have here in terraform - we must deal with quoto on each deployment.
You will run into a default 0.0 quota on GPUS_ALL_REGIONS by default for most google cloud organizations unless you have already negotiated extended quota for your org.
Not to worry as this particular GPU quota usually will be approved for 1.0 within 2 min.  Asking for over 1 GPU will depend on your spend history and may take more time.
After quota is received - rerun the terraform apply and the VM will get deployed.


```
google_compute_subnetwork.main: Creation complete after 33s [id=projects/gce-nvidia-old-8eby/regions/us-east1/subnetworks/main-us-east1]
google_compute_instance.instance: Creating...
google_compute_instance.instance: Still creating... [10s elapsed]
╷
│ Error: Error waiting for instance to create: Quota 'GPUS_ALL_REGIONS' exceeded.  Limit: 0.0 globally.
│       metric name = compute.googleapis.com/gpus_all_regions
│       limit name = GPUS-ALL-REGIONS-per-project
│       dimensions = map[global:global]
```

Navigate to IAM | Quotas - https://console.cloud.google.com/iam-admin/quotas?project=gce-nvidia-old-8eby&supportedpurview=project&pageState=(%22allQuotasTable%22:(%22f%22:%22%255B%257B_22k_22_3A_22Metric_22_2C_22t_22_3A10_2C_22v_22_3A_22_5C_22compute.googleapis.com%252Fgpus_all_regions_5C_22_22_2C_22s_22_3Atrue_2C_22i_22_3A_22metricName_22%257D%255D%22))

```
Thank you for submitting Case # (ID:572528c6ec144f86ac) to Google Cloud Platform support for the following quota:
Change GPUs (all regions) from 0 to 1

wait 60 sec, check your mail

Your quota request for gce-nvidia-old-8eby has been approved and your project quota has been adjusted according to the following requested limits:

+------------------+------------+--------+-----------------+----------------+
| NAME             | DIMENSIONS | REGION | REQUESTED LIMIT | APPROVED LIMIT |
+------------------+------------+--------+-----------------+----------------+
| GPUS_ALL_REGIONS |            | GLOBAL |               1 |              1 |
+------------------+------------+--------+-----------------+----------------+

After approval, Quotas can take up to 15 min to be fully visible in the Cloud Console and available to you.

rerun terraform

terraform apply -var-file=override.tfvars -auto-approve

Plan: 1 to add, 0 to change, 0 to destroy.
google_compute_instance.instance: Creation complete after 37s [id=projects/gce-nvidia-old-8eby/zones/us-east1-c/instances/nvidia-l4-vm]
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

enabled_services = tolist([
  "cloudresourcemanager.googleapis.com",
  "compute.googleapis.com",
  "iam.googleapis.com",
  "orgpolicy.googleapis.com",
  "serviceusage.googleapis.com",
])
instance_machine_type = "g2-standard-4"
instance_nat_ip = "34.138.110.121"
instance_network = "default"
instance_self_link = "https://www.googleapis.com/compute/v1/projects/gce-nvidia-old-8eby/zones/us-east1-c/instances/nvidia-l4-vm"
instance_zone = "us-east1-c"
project_id = "gce-nvidia-old-8eby"
project_number = "689724408163"
services_ready_dependency = "2026-01-22T19:39:51Z"
```
