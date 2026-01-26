resource "google_folder" "subfolder" {
  display_name = "subfolder"
  parent       = "folders/${var.parent_folder_id}"
  # only empty folders can be deleted - if there are out-of-band sub projects or folders - terraform destroy will fail as expected
  # "@type": "type.googleapis.com/google.rpc.PreconditionFailure","description": "The folder being deleted is non-empty.",
  deletion_protection = false # Explicitly set to false
}