# GCE VM with 1 or more L4 GPUs, NVIDIA DL image and associated GCP project/VPC

GPT-OSS:20b Tokens/sec for various M series and NVidia Ampere, Ada and Grace Blackwell GPUs

20260120 - https://github.com/ObrienlabsDev/blog/issues/160 and https://github.com/ObrienlabsDev/gcp-infrastructure-as-code/tree/main/m10-3rdparty/m11-nvidia-gce-terraform-ubuntu

<img width="843" height="516" alt="Image" src="Screenshot%202026-01-25%20at%2010.11.29.png" />

## Usage
Modify the variables in override.tfvars and create/edit the bucket in backet.tf first.

```
gcloud storage buckets create gs://ops-cicd-olx --project=ops-cicd-olx --location=northamerica-northeast1
```

## Terraform apply
All the GCP infrastructure is in IaC (Infrastructure as Code) in Terraform.  Perform the following actions to deploy the Nvidia VM.

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
michael@cloudshell:~ (ops-cicd-old)$ gcloud compute ssh --zone "us-east1-c" "nvidia-l4-vm" --project "gce-nvidia-old-8eby"
Updating project ssh metadata...working.Updated [https://www.googleapis.com/compute/v1/projects/gce-nvidia-old-8eby].                                                                                                         
Updating project ssh metadata...done.                                                                                                                                                                                         
Waiting for SSH key to propagate.
Warning: Permanently added 'compute.501942149384749533' (ED25519) to the list of known hosts.

 System information as of Tue Jan 27 14:45:52 UTC 2026

  System load:  0.26               Temperature:           29.9 C
  Usage of /:   5.9% of 122.94GB   Processes:             159
  Memory usage: 2%                 Users logged in:       0
  Swap usage:   0%                 IPv4 address for ens4: 10.10.0.2

Expanded Security Maintenance for Applications is not enabled.

6 updates can be applied immediately.
5 of these updates are standard security updates.
To see these additional updates run: apt list --upgradable

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status



The following GCP CLI version has been pre-installed. Begin using the GCP CLI by first configuring your credentials using 'gcloud init'

Google Cloud SDK 541.0.0


Welcome to the NVIDIA GPU Cloud image.  This image provides an optimized
environment for running the deep learning and HPC containers from the
NVIDIA GPU Cloud Container Registry.  Many NGC containers are freely
available.  However, some NGC containers require that you log in with
a valid NGC API key in order to access them.  This is indicated by a
"pull access denied for xyz ..." or "Get xyz: unauthorized: ..." error
message from the daemon.

Documentation on using this image and accessing the NVIDIA GPU Cloud
Container Registry can be found at
  http://docs.nvidia.com/ngc/index.html

Last login: Thu Jan 22 20:28:24 2026 from 35.235.243.209
Error while loading conda entry point: conda-libmamba-solver (cannot import name 'Spinner' from 'conda.common.io' (/opt/miniforge/lib/python3.12/site-packages/conda/common/io.py))
michael@nvidia-l4-vm:~$ nvidia-smi
Tue Jan 27 14:46:15 2026       
+-----------------------------------------------------------------------------------------+
| NVIDIA-SMI 570.172.08             Driver Version: 570.172.08     CUDA Version: 12.8     |
|-----------------------------------------+------------------------+----------------------+
| GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |
| Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
|                                         |                        |               MIG M. |
|=========================================+========================+======================|
|   0  NVIDIA L4                      On  |   00000000:00:03.0 Off |                    0 |
| N/A   31C    P8             11W /   72W |       0MiB /  23034MiB |      0%      Default |
|                                         |                        |                  N/A |
+-----------------------------------------+------------------------+----------------------+
                                                                                         
+-----------------------------------------------------------------------------------------+
| Processes:                                                                              |
|  GPU   GI   CI              PID   Type   Process name                        GPU Memory |
|        ID   ID                                                               Usage      |
|=========================================================================================|
|  No running processes found                                                             |
+-----------------------------------------------------------------------------------------+
michael@nvidia-l4-vm:~$ ls
README.txt
michael@nvidia-l4-vm:~$ git clone https://github.com/ObrienlabsDev/gcp-infrastructure-as-code.git
Cloning into 'gcp-infrastructure-as-code'...
remote: Enumerating objects: 725, done.
remote: Counting objects: 100% (248/248), done.
remote: Compressing objects: 100% (187/187), done.
remote: Total 725 (delta 159), reused 121 (delta 59), pack-reused 477 (from 1)
Receiving objects: 100% (725/725), 172.27 KiB | 6.15 MiB/s, done.
Resolving deltas: 100% (461/461), done.
michael@nvidia-l4-vm:~$ ls
README.txt  gcp-infrastructure-as-code
michael@nvidia-l4-vm:~$ cd gcp-infrastructure-as-code/
michael@nvidia-l4-vm:~/gcp-infrastructure-as-code$ cd m10-3rdparty/m11-nvidia-gce-terraform-ubuntu/
michael@nvidia-l4-vm:~/gcp-infrastructure-as-code/m10-3rdparty/m11-nvidia-gce-terraform-ubuntu$ ls
 README.md                                apply.sh     main.tf                 metadata.yaml       outputs.tf        providers.tf   vars.sh       vm.tf
'Screenshot 2026-01-25 at 10.11.29.png'   backend.tf   metadata.display.yaml   ollama-gpt-oss.sh   override.tfvars   variables.tf   versions.tf   vpc.tf
michael@nvidia-l4-vm:~/gcp-infrastructure-as-code/m10-3rdparty/m11-nvidia-gce-terraform-ubuntu$ vi ollama-gpt-oss.sh 
michael@nvidia-l4-vm:~/gcp-infrastructure-as-code/m10-3rdparty/m11-nvidia-gce-terraform-ubuntu$ ./ollama-gpt-oss.sh 
Tue Jan 27 14:48:18 2026       
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
                                                                                         
+-----------------------------------------------------------------------------------------+
| Processes:                                                                              |
|  GPU   GI   CI              PID   Type   Process name                        GPU Memory |
|        ID   ID                                                               Usage      |
|=========================================================================================|
|  No running processes found                                                             |
+-----------------------------------------------------------------------------------------+
>>> Installing ollama to /usr/local
>>> Downloading ollama-linux-amd64.tar.zst
######################################################################## 100.0%
>>> Creating ollama user...
>>> Adding ollama user to render group...
>>> Adding ollama user to video group...
>>> Adding current user to ollama group...
>>> Creating ollama systemd service...
>>> Enabling and starting ollama service...
Created symlink /etc/systemd/system/default.target.wants/ollama.service → /etc/systemd/system/ollama.service.
>>> NVIDIA GPU installed.
pulling manifest 
pulling e7b273f96360: 100% ▕████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▏  13 GB                         
pulling fa6710a93d78: 100% ▕████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▏ 7.2 KB                         
pulling f60356777647: 100% ▕████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▏  11 KB                         
pulling d8ba2f9a17b3: 100% ▕████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▏   18 B                         
pulling 776beb3adb23: 100% ▕████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▏  489 B                         
verifying sha256 digest 
writing manifest 
success 
>>> Send a message (/? for h

>>> which model are you
Thinking...
The user asks "which model are you". We need to answer in a short answer with only the model. So: "ChatGPT (GPT-4)".
...done thinking.

ChatGPT (GPT‑4)

total duration:       1.397176535s
load duration:        314.284502ms
prompt eval count:    71 token(s)
prompt eval duration: 99.851596ms
prompt eval rate:     711.06 tokens/s
eval count:           50 token(s)
eval duration:        850.042902ms
eval rate:            58.82 tokens/s
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
