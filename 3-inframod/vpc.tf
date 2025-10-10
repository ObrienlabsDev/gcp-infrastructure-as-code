# from https://cloud.google.com/vpc/docs/create-modify-vpc-networks#create-custom-network

resource "google_compute_network" "vpc_network" {
  project                 = var.project_id 
  name                    = var.vpc_name
  auto_create_subnetworks = false
  mtu                     = 1460
}


module "test-vpc-module" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 12.0"
  project_id   = var.project_id 
  network_name = var.vpc_name
  mtu          = 1460

  subnets = [
    {
      subnet_name   = "subnet-01"
      subnet_ip     = "10.10.10.0/24"
      subnet_region = "northamerica-northeast1"
    },
    {
      subnet_name           = "subnet-02"
      subnet_ip             = "10.10.20.0/24"
      subnet_region         = "northamerica-northeast1"
      subnet_private_access = "true"
      subnet_flow_logs      = "false"
    },
    {
      subnet_name               = "subnet-03"
      subnet_ip                 = "10.10.30.0/24"
      subnet_region             = "northamerica-northeast1"
      subnet_flow_logs          = "false"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
      subnet_flow_logs_sampling = 0.7
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
      subnet_flow_logs_filter   = "false"
    }
  ]
}