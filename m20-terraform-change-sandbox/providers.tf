provider "google" {
  #project = var.project_id
  # system wide label pairs - on project and vms
  default_labels = {
    team = "obrienlabs-dev"
    env = "development"
    iac = "terraform"
    contact = "michael-obrien4"

  }
  # Intentionally NOT setting "project" to the project we're about to create.
  region = var.region

  # OPTIONAL ADC
  #user_project_override = var.quota_project_id != null
  #billing_project       = var.quota_project_id
  #project               = var.quota_project_id
}


