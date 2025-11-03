#!/bin/bash


# VPC
#gcloud compute networks create dev-man --project=biometric-backend-gke-man-old --description=dev-man --subnet-mode=custom --mtu=1460 --bgp-routing-mode=global --bgp-best-path-selection-mode=legacy
#gcloud compute networks subnets create dev-man-sn --project=biometric-backend-gke-man-old --description=dev-man-sn --range=10.0.0.0/16 --stack-type=IPV4_ONLY --network=dev-man --region=us-central1 --enable-private-ip-google-access
#gcloud compute firewall-rules create dev-man-allow-custom --project=biometric-backend-gke-man-old --network=projects/biometric-backend-gke-man-old/global/networks/dev-man --description=Allows\ connection\ from\ any\ source\ to\ any\ instance\ on\ the\ network\ using\ custom\ protocols. --direction=INGRESS --priority=65534 --source-ranges=10.0.0.0/16 --action=ALLOW --rules=all
#gcloud compute firewall-rules create dev-man-allow-icmp --project=biometric-backend-gke-man-old --network=projects/biometric-backend-gke-man-old/global/networks/dev-man --description=Allows\ ICMP\ connections\ from\ any\ source\ to\ any\ instance\ on\ the\ network. --direction=INGRESS --priority=65534 --source-ranges=0.0.0.0/0 --action=ALLOW --rules=icmp
#gcloud compute firewall-rules create dev-man-allow-rdp --project=biometric-backend-gke-man-old --network=projects/biometric-backend-gke-man-old/global/networks/dev-man --description=Allows\ RDP\ connections\ from\ any\ source\ to\ any\ instance\ on\ the\ network\ using\ port\ 3389. --direction=INGRESS --priority=65534 --source-ranges=0.0.0.0/0 --action=ALLOW --rules=tcp:3389
#gcloud compute firewall-rules create dev-man-allow-ssh --project=biometric-backend-gke-man-old --network=projects/biometric-backend-gke-man-old/global/networks/dev-man --description=Allows\ TCP\ connections\ from\ any\ source\ to\ any\ instance\ on\ the\ network\ using\ port\ 22. --direction=INGRESS --priority=65534 --source-ranges=0.0.0.0/0 --action=ALLOW --rules=tcp:22


# autopilot
#gcloud beta container --project "biometric-backend-gke-man-old" clusters create-auto "dev-us-central1" --region "us-central1" --release-channel "stable" \
#  --enable-private-nodes --enable-dns-access --enable-k8s-tokens-via-dns --enable-k8s-certs-via-dns --enable-ip-access --enable-master-global-access --enable-google-cloud-access \
#   --network "projects/biometric-backend-gke-man-old/global/networks/dev-man" --subnetwork "projects/biometric-backend-gke-man-old/regions/us-central1/subnetworks/dev-man-sn" \
#   --cluster-ipv4-cidr "10.1.0.0/17" --binauthz-evaluation-mode=DISABLED --scopes=https://www.googleapis.com/auth/cloud-platform --enable-secret-manager
#gcloud compute routers create my-router --region us-central1 --network default --project=biometric-backend-gke-man-old
#gcloud beta compute routers nats create nat --router=my-router --region=us-central1 --auto-allocate-nat-external-ips --nat-all-subnet-ip-ranges --project=biometric-backend-gke-man-old

# manual
gcloud beta container --project "biometric-backend-gke-man-old" clusters create "dev2-man" --zone "us-central1-a" --no-enable-basic-auth --cluster-version "1.34.1-gke.1829001" \
  --release-channel "rapid" --machine-type "e2-medium" --image-type "COS_CONTAINERD" --disk-type "pd-balanced" --disk-size "80" --metadata disable-legacy-endpoints=true \
  --scopes "https://www.googleapis.com/auth/cloud-platform" --num-nodes "3" --logging=NONE --enable-ip-alias \
  --network "projects/biometric-backend-gke-man-old/global/networks/dev-man" --subnetwork "projects/biometric-backend-gke-man-old/regions/us-central1/subnetworks/dev-man-sn" \
  --cluster-ipv4-cidr "10.1.0.0/17" --no-enable-intra-node-visibility --default-max-pods-per-node "110" --enable-ip-access --security-posture=standard --workload-vulnerability-scanning=disabled \
  --enable-dataplane-v2 --no-enable-google-cloud-access --addons HorizontalPodAutoscaling,HttpLoadBalancing,GcePersistentDiskCsiDriver --enable-autoupgrade --enable-autorepair \
  --max-surge-upgrade 1 --max-unavailable-upgrade 0 --binauthz-evaluation-mode=DISABLED --no-enable-managed-prometheus --shielded-integrity-monitoring --no-shielded-secure-boot \
      --node-locations "us-central1-a"
#--enable-secret-manager --enable-secret-manager-rotation --secret-manager-rotation-interval "120s" \

#kubectl apply -f namespace.yaml
#kubectl apply -f deployment.yaml
#kubectl apply -f service.yaml