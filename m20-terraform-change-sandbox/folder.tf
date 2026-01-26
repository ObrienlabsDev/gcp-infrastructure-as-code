resource "google_folder" "subfolder" {
  display_name = "subfolder"
  parent       = "folders/${var.parent_folder_id}"

}