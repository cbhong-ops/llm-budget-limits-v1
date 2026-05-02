#!/bin/bash

# Google Cloud Project ID
#export PROJECT_ID=$(gcloud config get-value project)
export PROJECT_ID="apac-na-apigee-x-demo1"

# Cloud Run Region
export REGION="us-central1"

# Cloud Run Service Name
export SERVICE_NAME="llm-budget-ui"

# Service Account for Cloud Run
# TODO: 실제 사용하는 서비스 어카운트 이메일로 수정하세요.
export UI_SERVICE_ACCOUNT="sa-aigw@$PROJECT_ID.iam.gserviceaccount.com"

# Apigee Settings
export APIGEE_ORG="$PROJECT_ID"
export APIGEE_ENV="eval" # 필요에 따라 변경하세요.
export PROXY_NAME="llm-budget-limits-v1"

