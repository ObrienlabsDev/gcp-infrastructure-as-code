## Enable services on boot project
```
gcloud services enable cloudbilling.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable iam.googleapis.com

```

## Create a terraform state storage bucket
- nane1 regional bucket
```
gcloud storage buckets create gs://ops-cicd-old --location=northamerica-northeast1
```