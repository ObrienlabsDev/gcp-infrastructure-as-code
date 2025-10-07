#!/bin/bash
  SEED_PROJECT=gcp-infrastructure-as-code
  gcloud config set project $SEED_PROJECT
  PROJECT_NUMBER=$(gcloud projects describe $SEED_PROJECT  --format='value(projectNumber)')
  echo "Project Number: $PROJECT_NUMBER"

