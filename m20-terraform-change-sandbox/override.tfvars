goog_cm_deployment_name = "nvidia-l4"
# ol-ty
billing_account = "01A7A4-2FC08D-3C106E"
service_enablement_wait = "90s"

# gcp-archetypes-test
folder_id = "227323786500"
#project_id = "cuda-old"
# TODO: add random IP postfix
project_id = "gce-nvidia-test-old"
project_name = "gce-nvidia-test-old"

# gcloud projects describe "gce-nvidia-olx" --format="value(projectNumber)"
#project_number = "196717963363"
enabled_services = [
    "serviceusage.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "compute.googleapis.com",
    "orgpolicy.googleapis.com",
  ]

# vpc
region = "us-east1"
zone = "us-east1-c"
subnet_cidr = "10.10.0.0/24"
ssh_source_ranges = ["0.0.0.0/0"] #["203.0.113.10/32"] 
assign_external_ip = true

# GPU
accelerator_count = 1
accelerator_type = "nvidia-l4"
source_image = "projects/mpi-nvidia-ngc-public/global/images/nvidia-gpu-cloud-vmi-base-2025-9-1-x86-64"