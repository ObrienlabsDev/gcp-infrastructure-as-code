// GITHUB_PAT is the access token of the personal access token in GitHub.
variable "github_pat" {
  description = "github pat"
  type        = string
}

// PROJECT_NUMBER is your Google Cloud project number.
variable "project_number" {
  type        = string
  default     = "319811514193"
}
// SECRET_ID is the ID of your token or secret in Secret Manager.
variable "secret_id" {
  type        = string
}

// PROJECT_ID is your Google Cloud project ID.
variable "project_id" {
  type        = string
}

// REGION is the region for your connection.
variable "region" {
  type        = string
  default     = "northamerica-northeast1"
}

// CONNECTION_NAME is a name for your connection as it will appear in Cloud Build.
variable "connection_name" {
  type        = string
}

// INSTALLATION_ID is the installation ID of your Cloud Build GitHub app. Your installation ID can be found in the URL of your Cloud Build GitHub App. In the following URL, https://github.com/settings/installations/1234567, the installation ID is the numerical value 1234567.
variable "installation_id" {
  type        = string
}
