variable "project_id" {
  type        = string
}

variable "goog_cm_deployment_name" {
  type        = string
}

variable "source_image" {
  type        = string
}

variable "region" {
  type        = string
}

variable "zone" {
  type        = string
}

variable "machine_type" {
  type        = string
}

variable "boot_disk_type" {
  type        = string
}

variable "boot_disk_size" {
  description = "The boot disk size for the VM instance in GBs"
  type        = number
}

variable "networks" {
  type        = list(string)
  # required default to pass terraform validation before dynamic network provisioning
  default     = ["default"]
}

variable "sub_networks" {
  type        = list(string)
  default     = []
}

variable "external_ips" {
  type        = list(string)
  default     = ["EPHEMERAL"]
}

variable "accelerator_type" {
  type        = string
}

variable "accelerator_count" {
  type        = number
}

variable "enable_cloud_api" {
  type        = bool
  default     = true
}

variable "project_name" {
  type        = string
}

variable "billing_account" {
  type        = string
}

variable "folder_id" {
  type        = string
  default     = null
}

variable "auto_create_network" {
  type        = bool
  default     = false
}

variable "labels" {
  # project labels
  type        = map(string)
  default     = {}
}

variable "enabled_services" {
  type        = set(string)
  default = [
    "serviceusage.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "compute.googleapis.com",
    "orgpolicy.googleapis.com",
  ]
}

variable "service_enablement_wait" {
  #  avoid eventual-consistency wait state
  type        = string
}

variable "disable_guest_attributes_access" {
  description = <<EOT
If true, enforces the Org Policy constraint compute.disableGuestAttributesAccess (disables reading guest attributes via the Compute API).
If false, sets it to not enforced at the project level.
EOT
  type    = bool
  default = false #true
}

# Validation: you must set exactly one of org_id or folder_id.
locals {
#  org_set    = var.org_id != null && var.org_id != ""
  folder_set = var.folder_id != null && var.folder_id != ""
}

variable "subnet_cidr" {
  type        = string
}

# SSH access pattern:
variable "ssh_via_iap" {
  type        = bool
  default     = false #true
}

variable "ssh_source_ranges" {
  # when not using IAP
  type        = list(string)
}

variable "assign_external_ip" {
  type        = bool
  default     = true #false
  description = "If true: VM gets a public IP. (Not recommended unless you restrict ssh_source_ranges.)"
}