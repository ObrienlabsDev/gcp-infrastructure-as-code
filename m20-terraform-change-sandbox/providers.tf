provider "google" {
  #project = var.project_id
  default_labels = {
    goog-partner-solution = "isol_plb32_0014m00001h36sfqaq_ldcwv2kqy3qx5iqd2clmass7maq6qmfu"
  }
  # Intentionally NOT setting "project" to the project we're about to create.
  region = var.region

  # OPTIONAL ADC
  #user_project_override = var.quota_project_id != null
  #billing_project       = var.quota_project_id
  #project               = var.quota_project_id
}


