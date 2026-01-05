terraform {
  backend "gcs" {
    bucket = "ops-cicd-old"
    prefix = "terraform/m4-ml-saas/state"
  }
}
