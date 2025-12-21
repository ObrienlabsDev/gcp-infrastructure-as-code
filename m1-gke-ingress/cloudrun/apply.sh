#!/bin/bash


create_roles_services() {
# check expiry https://cloud.google.com/sdk/gcloud/reference/projects/add-iam-policy-binding

echo "Adding roles to project for user: ${USER_EMAIL}"
# owner for now
gcloud projects add-iam-policy-binding $CC_PROJECT_ID  --member=user:$USER_EMAIL --role=roles/owner --quiet > /dev/null 1>&1

#gcloud projects add-iam-policy-binding $CC_PROJECT_ID  --member=user:$USER_EMAIL --role=roles/ml.admin --quiet > /dev/null 1>&1
#gcloud projects add-iam-policy-binding $CC_PROJECT_ID  --member=user:$USER_EMAIL --role=roles/aiplatform.admin --quiet > /dev/null 1>&1
#gcloud projects add-iam-policy-binding $CC_PROJECT_ID  --member=user:$USER_EMAIL --role=roles/billing.projectManager --quiet > /dev/null 1>&1
# for SA impersonation
gcloud projects add-iam-policy-binding $CC_PROJECT_ID  --member=user:$USER_EMAIL --role=roles/iam.serviceAccountTokenCreator --quiet > /dev/null 1>&1

   # enable apis
   echo "Enabling APIs"

  # artifact registry ok
  # gcloud services enable artifactregistry.googleapis.com

  # compute
  gcloud services enable compute.googleapis.com

  # run
  gcloud services enable run.googleapis.com
  #gcloud services enable cloudapis.googleapis.com 
  gcloud services enable cloudbuild.googleapis.com 
  #gcloud services enable storage-component.googleapis.com 
  #gcloud services enable cloudkms.googleapis.com 
  #gcloud services enable logging.googleapis.com 
  #gcloud services enable cloudfunctions.googleapis.com

  # BigQuery ok
  #gcloud services enable bigquerymigration.googleapis.com
  #gcloud services enable bigquery.googleapis.com
  #gcloud services enable bigquerystorage.googleapis.com
  #gcloud services enable krmapihosting.googleapis.com 
  gcloud services enable container.googleapis.com
  #compute.googleapis.com
  #gcloud services enable cloudresourcemanager.googleapis.com 
  gcloud services enable cloudbilling.googleapis.com


  # add Kubernetes Cluster Admin to Cloud Build Service Agent
}

  source vars.sh

  PROJECT_ID=biometric-backend-gke-man-old
  ORGANIZATION_ID=$(gcloud projects get-ancestors $PROJECT_ID --format='get(id)' | tail -1)
  echo "Derived organization_id: $ORGANIZATION_ID"
  BILLING_ID=$(gcloud alpha billing projects describe $PROJECT_ID '--format=value(billingAccountName)' | sed 's/.*\///')
  echo "Derived billing_id: $BILLING_ID"




  # create custom service account
create_roles_services()

docker tag obrienlabs/magellan-nbi:0.0.4-ia64 us-central1-docker.pkg.dev/biometric-backend-cr-man-old/magellan/magellan-nbi:0.0.4-ia64
docker push central1-docker.pkg.dev/biometric-backend-cr-man-old/magellan/magellan-nbi:0.0.4-ia64

# verify addition of --allow-unauthenticated
gcloud alpha run deploy magellan-nbi /
--image=us-central1-docker.pkg.dev/biometric-backend-cr-man-old/magellan/magellan-nbi@sha256:e3d09b1f25156525dd1446a56dafae88a65012a48f95012235b938f032275d35 /
--no-invoker-iam-check /
--port=8080 /
--service-account=1089117545661-compute@developer.gserviceaccount.com /
--region=us-central1 /
--project=biometric-backend-cr-man-old


