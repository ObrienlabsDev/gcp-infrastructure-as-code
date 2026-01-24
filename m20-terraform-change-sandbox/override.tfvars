goog_cm_deployment_name = "nvidia-l4"
# ol-ty
billing_account = "01A7A4-2FC08D-3C106E"

# gcp-archetypes-test
folder_id = "227323786500"
# TODO: add random IP postfix
project_id = "gce-archetype-test-old"
project_name = "gce-archeytpe-test-old"

# gcloud projects describe "gce-nvidia-olx" --format="value(projectNumber)"
#project_number = "196717963363"
enabled_services = [
    "serviceusage.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "compute.googleapis.com",
    "orgpolicy.googleapis.com",
  ]
service_enablement_wait = "90s"

# vpc
region = "us-east1"
zone = "us-east1-c"
subnet_cidr = "10.10.0.0/24"
ssh_source_ranges = ["0.0.0.0/0"] #["203.0.113.10/32"] 
assign_external_ip = true
boot_disk_size = 128
boot_disk_type = "pd-ssd"

# GPU
accelerator_count = 1
accelerator_type = "nvidia-l4"
#machine_type = "g2-standard-4"
#source_image = "projects/mpi-nvidia-ngc-public/global/images/nvidia-gpu-cloud-vmi-base-2025-9-1-x86-64"

# CPU
machine_type = "c2d-highcpu-16"
source_image = "projects/ubuntu-os-cloud/global/images/ubuntu-minimal-2510-questing-amd64-v20260114"

