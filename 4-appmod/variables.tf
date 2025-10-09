// stub
// SECRET_ID is the ID of your token or secret in Secret Manager.
variable "secret_id" {
  type        = string
}

// PROJECT_ID is your Google Cloud project ID.
variable "project_id" {
  type        = string
}

variable "tf_bucket_id" {
  type = string
}

variable "authorized_networks" {
  default = [{
    name  = "sample-gcp-health-checkers-range"
    value = "130.211.0.0/28"
  }]
  type        = list(map(string))
  description = "List of mapped public networks authorized to access to the instances. Default - short range of GCP health-checkers IPs"
}

variable "db_name" {
  description = "The name of the SQL Database instance"
  default     = "example-postgres-public"
}