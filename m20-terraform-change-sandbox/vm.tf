
locals {
  network_interfaces = [for i, n in var.networks : {
    network     = n,
    subnetwork  = length(var.sub_networks) > i ? element(var.sub_networks, i) : null
    external_ip = length(var.external_ips) > i ? element(var.external_ips, i) : "NONE"
    }
  ]

  metadata = {
    google-logging-enable    = "0"
    google-monitoring-enable = "0"
  }
}

data "google_compute_default_service_account" "default" {
  project = google_project.this.project_id
  depends_on = [time_sleep.after_service_enablement]
}

resource "google_compute_instance" "instance" {
  name         = "${var.goog_cm_deployment_name}-vm"
  machine_type = var.machine_type
  zone         = var.zone
  project  = google_project.this.project_id
  depends_on = [time_sleep.after_service_enablement]

  tags = ["${var.goog_cm_deployment_name}-deployment","http-server", "https-server", "sandbox", "michael-obrien4"]

  labels = {
    goog-ec-src = "vm_add-tf"
  }

  boot_disk {
    device_name = "autogen-vm-tmpl-boot-disk"
    initialize_params {
      size  = var.boot_disk_size
      type  = var.boot_disk_type
      image = var.source_image
    }
    mode = "READ_WRITE"
  }

  metadata = local.metadata

  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false


  network_interface {
    subnetwork = google_compute_subnetwork.main.id
    #access_config {
    #  network_tier = "PREMIUM"
    #}

    # Public IP only if you explicitly want it:
    dynamic "access_config" {
      for_each = var.assign_external_ip ? [1] : []
      content {}
    }
  }
 
  # GPU 
  #guest_accelerator {
  #  type  = var.accelerator_type
  #  count = var.accelerator_count
  #}

  #scheduling {
    // GPUs do not support live migration
  #  on_host_maintenance = var.accelerator_count > 0 ? "TERMINATE" : "MIGRATE"
  #}

  # non-GPU
  scheduling {
    #on_host_maintenance = "TERMINATE" 
    preemptible         = false#true 
    #automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    provisioning_model  = "STANDARD"       
  }
  
  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  service_account {
    email = data.google_compute_default_service_account.default.email
    scopes = compact([
      "https://www.googleapis.com/auth/cloud.useraccounts.readonly",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write"
      , var.enable_cloud_api == true ? "https://www.googleapis.com/auth/cloud-platform" : null
    ])
  }
}

