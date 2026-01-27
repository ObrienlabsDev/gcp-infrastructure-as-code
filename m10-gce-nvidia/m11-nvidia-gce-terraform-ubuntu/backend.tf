terraform {
  backend "gcs" {
    bucket = "ops-cicd-old"
    prefix = "terraform/m11-nvidia-gce-terraform-ubuntu/state"
  }
}
