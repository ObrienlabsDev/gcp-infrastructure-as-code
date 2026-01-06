## Enable services on boot project
```
gcloud services enable cloudbilling.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable iam.googleapis.com

```

## Create a terraform state storage bucket
- nane1 regional bucket to match backend.tf
```
terraform {
  backend "gcs" {
    bucket = "ops-cicd-old"
    prefix = "terraform/m4-ml-saas/state"
  }
}

gcloud storage buckets create gs://ops-cicd-old --location=northamerica-northeast1
```

## ML SaaS services
```
  activate_apis = [
    "aiplatform.googleapis.com",
    "language.googleapis.com",
    "vision.googleapis.com",
    "documentai.googleapis.com",
    "cloudaicompanion.googleapis.com",
    "storage.googleapis.com",
```

## Deployment

```
terraform init
terraform plan
terraform apply --auto-approve
```