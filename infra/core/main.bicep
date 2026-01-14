
targetScope = 'resourceGroup'

// ---------------------------------------------
// Parameters
// ---------------------------------------------
@description('Name of the Storage Account')
param storageAccountName string

@description('Name of the Key Vault')
param keyVaultName string

@description('Name of the App Configuration Store')
param appConfigName string

@description('Name of the Application Insights instance')
param appInsightsName string

@description('Name of the Azure AI Foundry instance')
param aifName string

@description('Azure location (defaults to RG location)')
param location string = resourceGroup().location

@description('AAD Tenant ID for Key Vault')
param tenantId string

@description('App Configuration tier (free=Dev/Test, developer=Std)')
@allowed([
  'free'
  'developer'
])
param appConfigTier string = 'developer'

@description('Public network access setting for Key Vault')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Enabled'

@description('Kind for Azure AI Foundry (AIServices recommended)')
param kind string = 'AIServices'

@description('SKU for Azure AI Foundry (S0 recommended)')
param skuName string = 'S0'

// --- NEW PARAMS to support automated RBAC (Storage) ---
@description('Principal ID for GitHub OIDC federated identity (for Blob Contributor)')
param githubPrincipalId string = ''

@description('Principal ID for Azure AI Foundry\'s managed identity (Blob Reader)')
param foundryPrincipalId string = ''

@description('Optional principal ID for an agent runtime managed identity')
param agentPrincipalId string = ''


// ---------------------------------------------
// Storage (with RBAC)
// ---------------------------------------------
module storageModule './storage.bicep' = {
  name: 'storageModule'
  params: {
    storageAccountName: storageAccountName
    location: location
    githubPrincipalId: githubPrincipalId
    foundryPrincipalId: foundryPrincipalId
    agentPrincipalId: agentPrincipalId
  }
}


// ---------------------------------------------
// Key Vault
// ---------------------------------------------
module kvModule './keyvault.bicep' = {
  name: 'keyVault'
  params: {
    keyVaultName: keyVaultName
    location: location
    tenantId: tenantId
    publicNetworkAccess: publicNetworkAccess
  }
}


// ---------------------------------------------
// App Configuration
// ---------------------------------------------
module appConfigModule './appconfig.bicep' = {
  name: 'appConfig'
  params: {
    appConfigName: appConfigName
    location: location
    tier: appConfigTier
  }
}


// ---------------------------------------------
// Application Insights
// ---------------------------------------------
module appInsightsModule './appinsights.bicep' = {
  name: 'appInsights'
  params: {
    appInsightsName: appInsightsName
    location: location
  }
}


// ---------------------------------------------
// Azure AI Foundry
// ---------------------------------------------
module aifModule './ai-foundry.bicep' = {
  name: 'aiFoundry'
  params: {
    aifName: aifName
    location: location
    kind: kind
    skuName: skuName
  }
}


// ---------------------------------------------
// Outputs
// ---------------------------------------------
output storageAccountName string = storageModule.outputs.storageAccountName
output storageAccountId string = storageModule.outputs.storageAccountId

output keyVaultNameOut string = keyVaultName
output appConfigNameOut string = appConfigName
output appInsightsNameOut string = appInsightsName
// Output the Foundry MI principal ID if your module exposes it
// (If not, remove — depends on your ai-foundry.bicep implementation) 
