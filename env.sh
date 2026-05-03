#!/bin/bash

# Google Cloud Project ID
#export PROJECT_ID=$(gcloud config get-value project)
export PROJECT_ID="{YOUR_PROJECT_ID}"

# Cloud Run Region
export REGION="{CLOUD_RUN_REGION}"

# Cloud Run Service Name
export SERVICE_NAME="{CLOUD_RUN_SERVICE_NAME}"

# Service Account for Cloud Run
# TODO: 실제 사용하는 서비스 어카운트 이메일로 수정하세요.
export UI_SERVICE_ACCOUNT="{SEVICE_ACCNT_NAME}@$PROJECT_ID.iam.gserviceaccount.com"

# Apigee Settings
export APIGEE_ORG="$PROJECT_ID"
export APIGEE_ENV="{YOUR_APIGEE_ENV_NAME}" # 필요에 따라 변경하세요.
export PROXY_NAME="llm-budget-limits-v1"

