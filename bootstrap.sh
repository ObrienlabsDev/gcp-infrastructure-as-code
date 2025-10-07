#!/bin/bash

# 20251007 Michael O'Brien

set -e

source ./vars.sh

usage()
{
    echo "usage: <command> options:<p>"
    echo "syntax: ./bootstrap.sh -p project_id"
    echo "./bootstrap.sh --p gcp-infrastructure-as-code"
}

getRoles()
{
    array=( iam.serviceAccountTokenCreator roles/resourcemanager.folderAdmin roles/resourcemanager.organizationAdmin orgpolicy.policyAdmin resourcemanager.projectCreator billing.projectManager )
    for i in "${array[@]}"
    do
	    #echo "$i"
        ROLE=`gcloud organizations get-iam-policy $1 --filter="bindings.members:$2" --flatten="bindings[].members" --format="table(bindings.role)" | grep $i`
        if [ -z "$ROLE" ]
        then
            echo "roles/$i role missing"
            exit 1
        else
            echo "${ROLE} role set OK on super admin account"
        fi  
  done
}

no_args="true"
while getopts "p:" flag;
do
    case "${flag}" in
        p) PROJECT_ID=${OPTARG};;
        *) usage
           exit 1
           ;;
    esac
    no_args="false"
done

# Exit script and print usage if no arguments are passed.
if [[ $no_args == true ]]; then
    usage
    exit 1
fi

# get org and billing id based on project
ORG_ID=$(gcloud projects get-ancestors $PROJECT_ID --format='get(id)' | tail -1)
BILLING_ID=$(gcloud alpha billing projects describe $PROJECT_ID '--format=value(billingAccountName)' | sed 's/.*\///')
SERVICE_ACCOUNT=
CB_PROJECT_ID=

seed_gcp () {
  #SEED_PROJECT=gcp-infrastructure-as-code
  gcloud config set project $PROJECT_ID

  # enable APIs
  gcloud services enable serviceusage.googleapis.com 

  # verify super admin account has proper roles to use the terraform service account
  EMAIL=`gcloud config list account --format "value(core.account)"`
  echo "checking roles of current account: ${EMAIL}"

  PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID  --format='value(projectNumber)')
  echo "Project Number: $PROJECT_NUMBER"

  getRoles $ORG_ID $EMAIL
  echo "all roles set OK on super admin account:  ${EMAIL} - proceeding"
}


main () {
  seed_gcp
  status=$?
  echo "Status: ${status}"
  if [ $status == 0 ]
  then
    echo "GCP Cloud Build project created: ""${CB_PROJECT} \n"
    echo " Terraform Service account to be used for creating GCP infrastructure: " "${SERVICE_ACCOUNT} \n"
  else
    echo " GCP service account creation failed. Please debug and rerun"
  fi
  printf "**** Done ****\n"
}

main