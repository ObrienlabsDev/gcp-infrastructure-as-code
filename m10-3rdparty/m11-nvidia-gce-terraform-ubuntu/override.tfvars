goog_cm_deployment_name = "nvidia-l4"
# ol-ty
billing_account = "01A7A4-2FC08D-3C106E"
# gcp-archetypes
folder_id = "869569956904"
#project_id = "cuda-old"
project_id = "gce-nvidia-old-001"
project_name = "gce-nvidia-old-001"

# gcloud projects describe "gce-nvidia-olx" --format="value(projectNumber)"
#project_number = "196717963363"
region = "us-east1"
zone = "us-east1-c"
enabled_services = [
    "serviceusage.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "compute.googleapis.com",
    "orgpolicy.googleapis.com",
  ]

