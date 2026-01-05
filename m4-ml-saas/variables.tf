// stub

variable "project_suffix_id" {
  type        = string
}

variable "secret_id" {
  type        = string
}

#variable "vpc_name" {
#  type        = string
#}

variable "organization_id" {
  description = "The organization id for the associated services"
}

variable "folder_id" {
  description = "The folder id for the associated services"
}

variable "billing_account" {
  description = "The ID of the billing account to associate this project with"
}

variable "network_name" {
  description = "Name for Shared VPC network"
  default     = "shared-network"
}

variable "region" {
  description = "region"
  default     = "northamerica-northeast1"
}

