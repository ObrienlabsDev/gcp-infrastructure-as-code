terraform {
  backend "gcs" {
    bucket = "terraform-state-gke-old"
    prefix = "terraform/bootstrap/state"
  }
}
