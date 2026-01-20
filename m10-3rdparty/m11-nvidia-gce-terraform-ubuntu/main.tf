resource "google_project" "this" {
  project_id        = var.project_id
  name              = var.project_name
  billing_account   = var.billing_account
  auto_create_network = var.auto_create_network
  labels            = var.labels

  # Exactly one of these should be set:
  //org_id    = local.org_set ? var.org_id : null
  folder_id = local.folder_set ? var.folder_id : null

  #lifecycle {
  #  precondition {
  #    condition     = (local.org_set && !local.folder_set) || (!local.org_set && local.folder_set)
  #    error_message = "Set exactly one of org_id or folder_id."
  #  }
  #}
}

# Enable APIs (Service Usage is required to manage services). 
resource "google_project_service" "enabled" {
  for_each = var.enabled_services

  project = google_project.this.project_id
  service = each.value

  # Usually what you want for newly-created projects:
  disable_on_destroy         = false
  disable_dependent_services = false

  # Give slow enables time.
  timeouts {
    create = "30m"
    update = "40m"
    delete = "40m"
  }

  depends_on = [google_project.this]
}

# Barrier to avoid "API enabled but not yet usable" races.
# Provider docs & common issues acknowledge propagation delays. 
resource "time_sleep" "after_service_enablement" {
  depends_on = [google_project_service.enabled]

  create_duration = var.service_enablement_wait

  # Re-run the wait if the set of services changes.
  triggers = {
    project_id = google_project.this.project_id
    services   = join(",", sort(tolist(var.enabled_services)))
  }
}

###############################################################################
# Org Policy: compute.disableGuestAttributesAccess
###############################################################################

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

# ---------------------------------------------------------------------------
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
# ---------------------------------------------------------------------------
