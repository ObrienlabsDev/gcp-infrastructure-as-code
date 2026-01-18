variable "project_id" {
  description = "The ID of the project in which to provision resources."
  type        = string
}

variable "project_number" {
  description = "The project number - required for service account configuration."
  type        = string
}

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
