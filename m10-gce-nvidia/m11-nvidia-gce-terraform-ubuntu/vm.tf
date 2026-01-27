
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
  
  #project = var.project_id
  project = google_project.this.project_id

  depends_on = [time_sleep.after_service_enablement]
}

resource "google_compute_instance" "instance" {
  name         = "${var.goog_cm_deployment_name}-vm"
  machine_type = var.machine_type
  zone         = var.zone
  project  = google_project.this.project_id
  depends_on = [time_sleep.after_service_enablement]

  tags = ["${var.goog_cm_deployment_name}-deployment"]

  boot_disk {
    device_name = "autogen-vm-tmpl-boot-disk"

    initialize_params {
      size  = var.boot_disk_size
      type  = var.boot_disk_type
      image = var.source_image
    }
  }

  metadata = local.metadata

  # will force VM recreate
  metadata_startup_script = <<-EOT
    #!/bin/bash
    nvidia-smi
    export OLLAMA_SCHED_SPREAD=1
    export ROCR_VISIBLE_DEVICES=0,1
    export CUDA_VISIBLE_DEVICES=0,1
    # install and start the server
    curl -fsSL https://ollama.com/install.sh | sh
    # watch for huggingface model squatting
    # L4 currently is running 24G vram for Ada - up from 16G for Ampere
    #ollama run gpt-oss:20b --verbose
  EOT



  network_interface {
    subnetwork = google_compute_subnetwork.main.id

    # Public IP only if you explicitly want it:
    dynamic "access_config" {
      for_each = var.assign_external_ip ? [1] : []
      content {}
    }
  }
  #dynamic "network_interface" {
  #  for_each = local.network_interfaces
  #  content {
  #    network    = network_interface.value.network
  #    #subnetwork = network_interface.value.subnetwork
  #    # only 1 subnetwork
  #    subnetwork = google_compute_subnetwork.main.id
  #
  #    dynamic "access_config" {
  #      for_each = network_interface.value.external_ip == "NONE" ? [] : [1]
  #      content {
  #        nat_ip = network_interface.value.external_ip == "EPHEMERAL" ? null : network_interface.value.external_ip
  #      }
  #    }
  #  } 
  #}

  guest_accelerator {
    type  = var.accelerator_type
    count = var.accelerator_count
  }

  scheduling {
    // GPUs do not support live migration
    on_host_maintenance = var.accelerator_count > 0 ? "TERMINATE" : "MIGRATE"
  }
  
  service_account {
    #email = "${var.project_number}-compute@developer.gserviceaccount.com"//"default"
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
