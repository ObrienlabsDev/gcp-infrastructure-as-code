# GCE VM with 1 or more L4 GPUs, NVIDIA DL image and associated GCP project/VPC

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
