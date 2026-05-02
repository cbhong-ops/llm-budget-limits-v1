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

if [ -z "$APIGEE_ORG" ] || [ -z "$APIGEE_ENV" ] || [ -z "$PROXY_NAME" ]; then
  echo "Error: env.sh 파일에서 APIGEE_ORG, APIGEE_ENV, PROXY_NAME을 설정해주세요."
  exit 1
fi

echo "============================================================"
echo "Deploying API Proxy: $PROXY_NAME"
echo "Org: $APIGEE_ORG"
echo "Env: $APIGEE_ENV"
echo "============================================================"

echo "Getting access token..."
TOKEN=$(gcloud auth print-access-token)

if [ -z "$TOKEN" ]; then
  echo "Error: Failed to get access token."
  exit 1
fi

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed. Please install jq."
    exit 1
fi

# Check if apigeecli is installed
if ! command -v apigeecli &> /dev/null; then
    echo "apigeecli not found. Installing..."
    curl -s https://raw.githubusercontent.com/apigee/apigeecli/main/downloadLatest.sh | bash
    export PATH=$PATH:$HOME/.apigeecli/bin
fi

echo "Creating API Proxy bundle..."
# Assuming the folder 'apiproxy' is in the current directory
# We use the name specified in PROXY_NAME
REV=$(apigeecli apis create bundle -f apiproxy -n "$PROXY_NAME" --org "$PROJECT" --default-token --disable-check | jq -r '.revision')

if [ -z "$REV" ] || [ "$REV" == "null" ]; then
  echo "Error: Failed to create bundle or extract revision."
  exit 1
fi

echo "Deploying revision $REV..."
apigeecli apis deploy --wait --name "$PROXY_NAME" --ovr --rev "$REV" --org "$APIGEE_ORG" --env "$APIGEE_ENV" --default-token --sa "$PROXY_SERVICE_ACCOUNT"


echo "============================================================"
echo "Deployment completed successfully!"
echo "============================================================"
