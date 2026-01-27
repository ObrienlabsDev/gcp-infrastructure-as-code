#


resource "google_org_policy_policy" "resource_locations" {
  # either on the project or super folder
  #name = "projects/${google_project.this.number}/policies/gcp.resourceLocations"
  #parent = "projects/${google_project.this.number}"
  name = "folders/${google_folder.subfolder.folder_id}/policies/gcp.resourceLocations"
  parent = "folders/${google_folder.subfolder.folder_id}"
  spec {
    rules {
      values {
        allowed_values = [
          "in:northamerica-northeast1-locations",
          "in:northamerica-northeast2-locations",
          "in:us-east1-locations"
        ]
      }
    }
  }
  depends_on = [google_project.this]
}

# Recommended (Org Policy API v2):
# NOTE: responses use project NUMBER in the policy name, so we build it that way.
resource "google_org_policy_policy" "disable_guest_attributes_access" {
  name   = "projects/${google_project.this.number}/policies/compute.disableGuestAttributesAccess"
  parent = "projects/${google_project.this.number}"

  spec {
    rules {
      # For boolean constraints, enforce TRUE means "constraint enforced".
      # (The constraint itself is "disable guest attributes access".)
      enforce = var.disable_guest_attributes_access ? "TRUE" : "FALSE"
    }
  }
  depends_on = [google_project.this]
}

# Alternative (legacy / v1) resource:
# google_project_organization_policy is superseded by google_org_policy_policy. 
#
# resource "google_project_organization_policy" "disable_guest_attributes_access" {
#   project    = google_project.this.project_id
#   constraint = "compute.disableGuestAttributesAccess"
#   boolean_policy {
#     enforced = var.disable_guest_attributes_access
#   }
# }
