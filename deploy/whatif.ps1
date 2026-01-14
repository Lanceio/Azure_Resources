
# deploy/whatif.ps1
param(
  [Parameter(Mandatory=$true)][string]$SubscriptionId,
  [Parameter(Mandatory=$true)][string]$ResourceGroupName,
  [Parameter(Mandatory=$true)][string]$ParamFile,   # e.g. ./infra/params/dev.bicepparam
  [string]$Location = 'australiaeast',
  [string]$TemplateFile = './infra/core/main.bicep'
)

$ErrorActionPreference = 'Stop'

az account set --subscription $SubscriptionId
az group create -n $ResourceGroupName -l $Location

az deployment group what-if `
  --name "whatif-$(Get-Date -Format 'yyyyMMdd-HHmmss')" `
  --resource-group $ResourceGroupName `
  --template-file $TemplateFile `
  --parameters $ParamFile
