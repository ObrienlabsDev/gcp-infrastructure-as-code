variable "project_id" {
  description = "The ID of the project in which to provision resources."
  type        = string
}

#variable "project_number" {
#  description = "The project number - required for service account configuration."
#  type        = string
#}

variable "goog_cm_deployment_name" {
  description = "The name of the deployment and VM instance."
  type        = string
}

variable "source_image" {
  description = "The image name for the disk for the VM instance."
  type        = string
  default     = "projects/mpi-nvidia-ngc-public/global/images/nvidia-gpu-cloud-vmi-base-2025-9-1-x86-64"
}

variable "region" {
  description = "The region for the solution to be deployed."
  type        = string
  default     = "us-east1-c"
}

variable "zone" {
  description = "The zone for the solution to be deployed."
  type        = string
  default     = "us-east1-c"
}

variable "machine_type" {
  description = "The machine type to create, e.g. e2-small"
  type        = string
  default     = "g2-standard-4"
}

variable "boot_disk_type" {
  description = "The boot disk type for the VM instance."
  type        = string
  default     = "pd-ssd"
}

variable "boot_disk_size" {
  description = "The boot disk size for the VM instance in GBs"
  type        = number
  default     = 128
}

variable "networks" {
  description = "The network name to attach the VM instance."
  type        = list(string)
  default     = ["default"]
}

variable "sub_networks" {
  description = "The sub network name to attach the VM instance."
  type        = list(string)
  default     = []
}

variable "external_ips" {
  description = "The external IPs assigned to the VM for public access."
  type        = list(string)
  default     = ["EPHEMERAL"]
}

variable "accelerator_type" {
  description = "The accelerator type resource exposed to this instance. E.g. nvidia-tesla-p100."
  type        = string
  default     = "nvidia-l4"
}

variable "accelerator_count" {
  description = "The number of the guest accelerator cards exposed to this instance."
  type        = number
  default     = 1
}

variable "enable_cloud_api" {
  description = "Allow full access to all of Google Cloud Platform APIs on the VM"
  type        = bool
  default     = true
}



#variable "project_id" {
#  description = "Globally-unique GCP project_id (e.g. my-team-prod-1234)."
#  type        = string
#}

variable "project_name" {
  description = "Human-readable project name."
  type        = string
}

variable "billing_account" {
  description = "Billing account ID (e.g. 000000-000000-000000)."
  type        = string
}

#variable "org_id" {
#  description = "Organization ID (set this OR folder_id)."
#  type        = string
#  default     = null
#}

variable "folder_id" {
  description = "Folder ID (set this OR org_id). Example: folders/1234567890 or just 1234567890 depending on your conventions."
  type        = string
  default     = null
}

variable "auto_create_network" {
  description = "Whether to create the default VPC network in the new project."
  type        = bool
  default     = false
}

variable "labels" {
  description = "Project labels."
  type        = map(string)
  default     = {}
}

variable "enabled_services" {
  description = "APIs to enable in the new project (serviceusage is used under the hood)."
  type        = set(string)

  # Choose your own defaults; these are common “bootstrap” ones.
  default = [
    "serviceusage.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "compute.googleapis.com",
    "orgpolicy.googleapis.com",
  ]
}

variable "service_enablement_wait" {
  description = "How long to wait after enabling APIs to avoid eventual-consistency races."
  type        = string
  default     = "90s"
}

variable "disable_guest_attributes_access" {
  description = <<EOT
If true, enforces the Org Policy constraint compute.disableGuestAttributesAccess (disables reading guest attributes via the Compute API).
If false, sets it to not enforced at the project level.
EOT
  type    = bool
  default = false #true
}

#variable "default_region" {
#  description = "Default region for the provider (not used by global resources, but convenient)."
#  type        = string
#  default     = "us-central1"
#}

variable "quota_project_id" {
  description = <<EOT
Optional 'quota project' to use for API requests when using User ADC.
If you see errors saying an API 'requires a quota project', set this.
EOT
  type    = string
  default = null
}

# Validation: you must set exactly one of org_id or folder_id.
locals {
#  org_set    = var.org_id != null && var.org_id != ""
  folder_set = var.folder_id != null && var.folder_id != ""
}


variable "subnet_cidr" {
  type        = string
  default     = "10.10.0.0/24"
  description = "CIDR range for the subnet."
}

# SSH access pattern:
variable "ssh_via_iap" {
  type        = bool
  default     = false #true
  description = "If true: no public IP; SSH via IAP TCP forwarding."
}

variable "ssh_source_ranges" {
  type        = list(string)
  default     = ["0.0.0.0/0"] #["203.0.113.10/32"] # replace with your IP/CIDR if using public SSH
  description = "Source IP ranges allowed to SSH when NOT using IAP."
}

variable "assign_external_ip" {
  type        = bool
  default     = true #false
  description = "If true: VM gets a public IP. (Not recommended unless you restrict ssh_source_ranges.)"
}