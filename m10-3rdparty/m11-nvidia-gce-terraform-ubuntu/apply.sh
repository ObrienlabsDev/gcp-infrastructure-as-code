#!/bin/bash
# This script is the preconditioning script for the boot project only - in order to be able to run terraform
source vars.sh

gcloud config set project $BOOT_PROJECT_ID

boot() {
  gcloud services enable compute.googleapis.com
  gcloud services enable cloudresourcemanager.googleapis.com
  gcloud services enable iam.googleapis.com
  gcloud services enable orgpolicy.googleapis.com
  gcloud services enable storage.googleapis.com
  # disable for non-autopilot
  # constraints/compute.vmExternalIPAccess

  # create bucket listed in backend.tf
}


boot





