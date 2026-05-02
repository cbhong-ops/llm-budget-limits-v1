#!/bin/bash

# Exit on error
set -e

# Source environment variables
if [ -f "./env.sh" ]; then
  source ./env.sh
else
  echo "Error: env.sh file not found."
  exit 1
fi

if [ -z "$PROJECT_ID" ] || [ "$UI_SERVICE_ACCOUNT" == "your-service-account@$PROJECT_ID.iam.gserviceaccount.com" ]; then
  echo "Error: env.sh 파일에서 UI_SERVICE_ACCOUNT를 올바르게 설정해주세요."
  exit 1
fi

echo "============================================================"
echo "Deploying $SERVICE_NAME to Cloud Run"
echo "Project: $PROJECT_ID"
echo "Region: $REGION"
echo "Service Account: $UI_SERVICE_ACCOUNT"
echo "============================================================"

# Cloud Run에 budget-ui 디렉토리 소스로 배포
gcloud run deploy $SERVICE_NAME \
  --source budget-ui \
  --region $REGION \
  --project $PROJECT_ID \
  --ingress all \
  --service-account $UI_SERVICE_ACCOUNT

echo "============================================================"
echo "Deployment completed successfully!"
echo "============================================================"
