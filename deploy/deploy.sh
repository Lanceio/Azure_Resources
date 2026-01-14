
#!/usr/bin/env bash
# deploy/deploy.sh
set -euo pipefail

SUBSCRIPTION_ID="${1:-383cf7d8-46ce-433f-9b54-ceac47c81c34}"
RESOURCE_GROUP="${2:-rg-ai-core}"
PARAM_FILE="${3:-./infra/params/dev.bicepparam}"
LOCATION="${4:-australiaeast}"
TEMPLATE_FILE="${5:-./infra/core/main.bicep}"

echo "Subscription: ${SUBSCRIPTION_ID}"
echo "Resource Group: ${RESOURCE_GROUP}"
echo "Param File: ${PARAM_FILE}"
echo "Location: ${LOCATION}"
echo "Template: ${TEMPLATE_FILE}"

az account set --subscription "${SUBSCRIPTION_ID}"
az group create -n "${RESOURCE_GROUP}" -l "${LOCATION}"

echo "Running what-if..."
az deployment group what-if \
  --name "whatif-$(date +%Y%m%d-%H%M%S)" \
  --resource-group "${RESOURCE_GROUP}" \
  --template-file "${TEMPLATE_FILE}" \
  --parameters "${PARAM_FILE}"

echo "Deploying..."
az deployment group create \
  --name "deploy-$(date +%Y%m%d-%H%M%S)" \
  --resource-group "${RESOURCE_GROUP}" \
  --template-file "${TEMPLATE_FILE}" \
  --parameters "${PARAM_FILE}"

echo "Done."
