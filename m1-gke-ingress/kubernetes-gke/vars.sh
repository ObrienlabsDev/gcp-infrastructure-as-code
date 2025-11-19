#!/bin/bash

export PROJECT_ID=biometric-backend-gke-man-old

#export GKE_REGION=us-central1
export GKE_REGION=us-east4
export GKE_ZONE=${GKE_REGION}-a
export GKE_CLUSTER_NAME=dev4-man
export GKE_VPC_NAME=dev4-man
export GKE_VPC_SN_NAME=${GKE_VPC_NAME}-sn
export VPC_NON_OVERLAPPING_CIDR="10.0.0.0"
export VPC_NON_OVERLAPPING_CIDR_PREFIX=16
export GKE_NON_OVERLAPPING_SUBNET_CIDR="10.1.0.0"
export GKE_NON_OVERLAPPING_SUBNET_CIDR_PREFIX=17

# underscore between region and gke_cluster_name not required
# Standard GKE
#export KUBECTL_CONTEXT=gke_${PROJECT_ID}_${GKE_REGION}_${GKE_CLUSTER_NAME}
# Autopilot GKE
export KUBECTL_CONTEXT=gke_${PROJECT_ID}_${GKE_ZONE}_${GKE_CLUSTER_NAME}

# Autopilot versions
#export GKE_AUTOPILOT_CLUSTER_VERSION="1.34.1-gke.1829001"
# 20251119: ERROR: (gcloud.beta.container.clusters.create) ResponseError: code=400, message=Master version must be one of 
# "RAPID" channel supported versions [1.31.13-gke.1139000, 1.31.13-gke.1231000, 1.31.13-gke.1377000, 
# 1.32.9-gke.1239000, 1.32.9-gke.1330000, 1.32.9-gke.1462000, 1.33.5-gke.1350000, 1.33.5-gke.1521000,
# 1.33.5-gke.1697000, 1.34.1-gke.2037001, 1.34.1-gke.2037002, 1.34.1-gke.2541000, 1.34.1-gke.2909000].
export GKE_AUTOPILOT_CLUSTER_VERSION="1.34.1-gke.2909000"