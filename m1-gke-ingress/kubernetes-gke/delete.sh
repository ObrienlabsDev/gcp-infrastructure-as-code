#!/bin/bash
#

source vars.sh

gcloud config set project $PROJECT_ID
# switch kubernetes context
gcloud container clusters get-credentials $GKE_CLUSTER_NAME --zone $GKE_ZONE --project $PROJECT_ID
kubectl config use-context $KUBECTL_CONTEXT
kubectl get nodes

kubernetes() {

kubectl delete -f managed-certificate.yaml
# remove reserve static IP
# remove NS A record (domain to IP)
# wait for propagation
kubectl delete -f ingress.yaml
kubectl delete -f service.yaml
kubectl delete -f deployment.yaml
kubectl delete -f namespace.yaml
}

echo "Deleting cluster: ${GKE_CLUSTER_NAME}"
gcloud container clusters delete $GKE_CLUSTER_NAME --zone $GKE_ZONE --quiet