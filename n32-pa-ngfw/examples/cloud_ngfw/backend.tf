terraform {
  backend "gcs" {
    bucket = "ops-cicd-old"
    prefix = "terraform/m32-pa-ngfw/state"
  }
}
