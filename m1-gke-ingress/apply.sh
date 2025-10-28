#!/bin/bash

  source vars.sh

  PROJECT_ID=biometric-backend-gke-man-old
  ORGANIZATION_ID=$(gcloud projects get-ancestors $PROJECT_ID --format='get(id)' | tail -1)
  echo "Derived organization_id: $ORGANIZATION_ID"
  BILLING_ID=$(gcloud alpha billing projects describe $PROJECT_ID '--format=value(billingAccountName)' | sed 's/.*\///')
  echo "Derived billing_id: $BILLING_ID"
  
  gcloud services enable container.googleapis.com
  gcloud services enable compute.googleapis.com

  gcloud beta container /
    --project "biometric-backend-gke-man-old" /
    clusters create-auto "dev" /
    --region "northamerica-northeast1" /
    --release-channel "stable" /
    --enable-private-nodes /
    --enable-dns-access /
    --enable-k8s-tokens-via-dns /
    --enable-k8s-certs-via-dns /
    --enable-ip-access /
    --enable-master-global-access /
    --enable-google-cloud-access /
    --network "projects/biometric-backend-gke-man-old/global/networks/default" /
    --subnetwork "projects/biometric-backend-gke-man-old/regions/northamerica-northeast1/subnetworks/default" /
    --cluster-ipv4-cidr "10.0.0.0/17" /
    --binauthz-evaluation-mode=DISABLED /
    --scopes=https://www.googleapis.com/auth/cloud-platform /
    --enable-secret-manager


