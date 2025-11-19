#!/bin/bash

source vars.sh


gcloud config set project $PROJECT_ID

boot() {
  gcloud services enable container.googleapis.com
  gcloud services enable compute.googleapis.com
  gcloud services enable certificatemanager.googleapis.com
  
  gcloud compute addresses list
  gcloud compute addresses create mageelan-obrienlabs-dev-ip --region=$GKE_REGION
  gcloud compute addresses list

  # disable for non-autopilot
  # constraints/compute.vmExternalIPAccess
}

infra() {
  gcloud compute networks create $GKE_VPC_NAME --project=$PROJECT_ID --description=$GKE_VPC_NAME --subnet-mode=custom --mtu=1460 --bgp-routing-mode=global --bgp-best-path-selection-mode=legacy
  gcloud compute networks subnets create $GKE_VPC_SN_NAME --project=$PROJECT_ID --description=$GKE_VPC_SN_NAME --range=${VPC_NON_OVERLAPPING_CIDR}/${VPC_NON_OVERLAPPING_CIDR_PREFIX} --stack-type=IPV4_ONLY --network=$GKE_VPC_NAME --region=$GKE_REGION --enable-private-ip-google-access
  gcloud compute firewall-rules create dev-man-allow-custom --project=$PROJECT_ID --network=projects/$PROJECT_ID/global/networks/$GKE_VPC_NAME --description=Allows\ connection\ from\ any\ source\ to\ any\ instance\ on\ the\ network\ using\ custom\ protocols. --direction=INGRESS --priority=65534 --source-ranges=10.0.0.0/16 --action=ALLOW --rules=all
  gcloud compute firewall-rules create dev-man-allow-icmp --project=$PROJECT_ID --network=projects/$PROJECT_ID/global/networks/$GKE_VPC_NAME --description=Allows\ ICMP\ connections\ from\ any\ source\ to\ any\ instance\ on\ the\ network. --direction=INGRESS --priority=65534 --source-ranges=0.0.0.0/0 --action=ALLOW --rules=icmp
  gcloud compute firewall-rules create dev-man-allow-rdp --project=$PROJECT_ID --network=projects/$PROJECT_ID/global/networks/$GKE_VPC_NAME --description=Allows\ RDP\ connections\ from\ any\ source\ to\ any\ instance\ on\ the\ network\ using\ port\ 3389. --direction=INGRESS --priority=65534 --source-ranges=0.0.0.0/0 --action=ALLOW --rules=tcp:3389
  gcloud compute firewall-rules create dev-man-allow-ssh --project=$PROJECT_ID --network=projects/$PROJECT_ID/global/networks/$GKE_VPC_NAME --description=Allows\ TCP\ connections\ from\ any\ source\ to\ any\ instance\ on\ the\ network\ using\ port\ 22. --direction=INGRESS --priority=65534 --source-ranges=0.0.0.0/0 --action=ALLOW --rules=tcp:22

  # reserve named IP for LB named magellan-obrienlabs-dev-ip and create an A record on the domain
}

#boot
infra

# autopilot
#gcloud beta container --project "$PROJECT_ID" clusters create-auto "$GKE_CLUSTER_NAME" --region "$GKE_REGION" --release-channel "stable" \
#  --enable-private-nodes --enable-dns-access --enable-k8s-tokens-via-dns --enable-k8s-certs-via-dns --enable-ip-access --enable-master-global-access --enable-google-cloud-access \
#   --network "projects/$PROJECT_ID/global/networks/$GKE_VPC_NAME" --subnetwork "projects/$PROJECT_ID/regions/$GKE_REGION/subnetworks/$GKE_VPC_SN_NAME" \
#   --cluster-ipv4-cidr $GKE_NON_OVERLAPPING_SUBNET_CIDR/${GKE_NON_OVERLAPPING_SUBNET_CIDR_PREFIX} --binauthz-evaluation-mode=DISABLED --scopes=https://www.googleapis.com/auth/cloud-platform --enable-secret-manager
#gcloud compute routers create my-router --region $GKE_REGION --network default --project=$PROJECT_ID
#gcloud beta compute routers nats create nat --router=my-router --region=$GKE_REGION --auto-allocate-nat-external-ips --nat-all-subnet-ip-ranges --project=$PROJECT_ID

# manual

gcloud beta container --project $PROJECT_ID clusters create "$GKE_CLUSTER_NAME" --zone "${GKE_REGION}-a" --no-enable-basic-auth --cluster-version "1.34.1-gke.1829001" \
  --release-channel "rapid" --machine-type "e2-medium" --image-type "COS_CONTAINERD" --disk-type "pd-balanced" --disk-size "80" --metadata disable-legacy-endpoints=true \
  --scopes "https://www.googleapis.com/auth/cloud-platform" --num-nodes "3" --logging=NONE --enable-ip-alias \
  --network "projects/$PROJECT_ID/global/networks/$GKE_VPC_NAME" --subnetwork "projects/$PROJECT_ID/regions/$GKE_REGION/subnetworks/$GKE_VPC_SN_NAME" \
  --cluster-ipv4-cidr ${GKE_NON_OVERLAPPING_SUBNET_CIDR}/${GKE_NON_OVERLAPPING_SUBNET_CIDR_PREFIX} --no-enable-intra-node-visibility --default-max-pods-per-node "110" --enable-ip-access --security-posture=standard --workload-vulnerability-scanning=disabled \
  --enable-dataplane-v2 --no-enable-google-cloud-access --addons HorizontalPodAutoscaling,HttpLoadBalancing,GcePersistentDiskCsiDriver --enable-autoupgrade --enable-autorepair \
  --max-surge-upgrade 1 --max-unavailable-upgrade 0 --binauthz-evaluation-mode=DISABLED --no-enable-managed-prometheus --shielded-integrity-monitoring --no-shielded-secure-boot \
      --node-locations "${GKE_REGION}-a"
#--enable-secret-manager --enable-secret-manager-rotation --secret-manager-rotation-interval "120s" \


# switch kubernetes context
gcloud container clusters get-credentials $GKE_CLUSTER_NAME --zone $GKE_ZONE --project $PROJECT_ID
kubectl config use-context $KUBECTL_CONTEXT
kubectl get nodes

kubectl apply -f namespace.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
# the managed-certificate must in the same namespace as the ingress - set the default in the context instead of the yaml
kubectl config set-context --current --namespace=magellan
kubectl apply -f managed-certificate.yaml
# reserve static IP
# DNS A record (domain to IP)
# wait for propagation
kubectl apply -f ingress.yaml
# wait for provisioning Status = Active
 kubectl describe managedcertificate managed-cert | grep Status
# check url
 kubectl get managedCertificate --all-namespaces
 echo "wait for up to 45 min for the certificate to pickup the DNS A record to the LB named static IP"




