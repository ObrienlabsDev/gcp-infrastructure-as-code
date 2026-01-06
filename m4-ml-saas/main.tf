// stub

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

module "project-factory" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 18.0"
  #name                    = "obrienlabs-sandbox2-ot"
  name              = "${var.project_suffix_id}-${random_string.suffix.result}"
  random_project_id       = true

  #org_id                  = var.organization_id
  folder_id               = var.folder_id
  billing_account         = var.billing_account
  #default_service_account = "deprivilege"
  auto_create_network = false
  default_network_tier = "PREMIUM" # https://cloud.google.com/network-tiers/docs/using-network-service-tiers PREMIUM/STANDARD
  grant_services_security_admin_role = true # for GKE firewall rule creation via GKE service agent
  # VertexAI: gcloud services enable aiplatform.googleapis.com
  # Cloud Vision: gcloud services enable vision.googleapis.com
  # Natural Language API: gcloud services enable language.googleapis.com
  #

  activate_apis = [
    "aiplatform.googleapis.com",
    "appengine.googleapis.com",
    "compute.googleapis.com", 
    "container.googleapis.com", 
    "cloudbilling.googleapis.com", 
    "secretmanager.googleapis.com"] # may require 2nd run - wait for service enablement
  deletion_policy = "DELETE"
}


// Create a secret containing the personal access token and grant permissions to the Service Agent
resource "google_secret_manager_secret" "github_token_secret" {
    project = module.project-factory.project_id
    secret_id = var.secret_id

    replication {
        auto {}
    }
}
