
resource "google_compute_network" "main" {
  project                 = google_project.this.project_id
  name                    = "main"
  auto_create_subnetworks = false

  depends_on = [time_sleep.after_service_enablement]
}

resource "google_compute_subnetwork" "main" {
  project       = google_project.this.project_id
  #name          = "main-${var.default_region}"
  name          = "main-${var.region}"
  #region        = var.default_region
  region        = var.region
  ip_cidr_range = var.subnet_cidr
  network       = google_compute_network.main.id

  depends_on = [time_sleep.after_service_enablement]
}

# If using IAP, allow from IAP TCP forwarding range 35.235.240.0/20 on port 22. :contentReference[oaicite:2]{index=2}
# If using direct SSH, restrict to your IP ranges (don't use 0.0.0.0/0). :contentReference[oaicite:3]{index=3}
resource "google_compute_firewall" "ssh" {
  project = google_project.this.project_id
  name    = "allow-ssh"
  network = google_compute_network.main.name

  direction = "INGRESS"
  allow {
    protocol = "tcp"
    #protocol = "all"
    ports    = ["22"]
  }

  source_ranges = var.ssh_via_iap ? ["35.235.240.0/20"] : var.ssh_source_ranges
  #target_tags   = ["ssh"]

  depends_on = [time_sleep.after_service_enablement]
}