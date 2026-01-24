terraform {
  backend "gcs" {
    bucket = "ops-cicd-old"
    prefix = "terraform/m20-terraform-change-sandbox/state"
  }
}
