terraform {
  backend "gcs" {
    bucket = "terraform-state-old"
    prefix = "terraform/bootstrap/state"
  }
}
