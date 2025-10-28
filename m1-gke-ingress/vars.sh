#!/bin/bash

# Copyright 2025 ObrienLabs Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

###
# UPDATE
export REGION=northamerica-northeast1
#export REGION=us-central1

#export VAR_GOOGLE_PROCESSOR_ID=491b42bf46846175


# current project - not the target project
#export BOOT_PROJECT_ID=$PROJECT_ID
export BOOT_PROJECT_ID=gcp-infrastructure-as-code
# generated project prefix
export KCC_PROJECT_NAME=gcp-infrastructure-as-code
# used for vpc, subnet, KCC cluster
export PREFIX=old


# repo from where we run the scripts
export SRC_REPO_STAGING=gcp-infrastructure-as-code
# for non gerrit
#export GITHUB_ORG=GoogleCloudPlatform
export GITHUB_ORG=ObrienlabsDev

# branch under use
#export CSR_BRANCH_OTHER_THAN_MAIN=canary
export CSR_BRANCH_OTHER_THAN_MAIN=main
export NETWORK=$REGION
export SUBNET=$NETWORK-sn
export ZONE=$REGION-a
export VPC=$NETWORK-vpc

export CIDR_VPC=10.0.0.0/16
# see cloud build yamls
export GKE_PROD=gke-prod
export BRANCH_PROD=main
