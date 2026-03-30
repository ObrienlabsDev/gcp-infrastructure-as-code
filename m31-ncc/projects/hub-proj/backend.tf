terraform {
  backend "gcs" {
    bucket = "ops-cicd-old"
    prefix = "terraform/m31-ncc/projects/hub-proj/main"
  }
}

