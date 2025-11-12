#!/bin/bash
#

source vars.sh

gcloud config set project $PROJECT_ID

kubernetes() {

# switch kubernetes context
gcloud container clusters get-credentials $GKE_CLUSTER_NAME --zone $GKE_ZONE --project $PROJECT_ID

kubectl delete -f managed-certificate.yaml
# remove reserve static IP
# remove NS A record (domain to IP)
# wait for propagation
kubectl delete -f ingress.yaml
kubectl delete -f service.yaml
kubectl delete -f deployment.yaml
kubectl delete -f namespace.yaml
}


gcloud container clusters delete $GKE_CLUSTER_NAME --zone $GKE_ZONE --quiet