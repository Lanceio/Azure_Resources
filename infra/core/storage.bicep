
targetScope = 'resourceGroup'

@description('Name of the Storage Account')
param storageAccountName string

@description('Azure location')
param location string

@description('SKU for Storage Account')
param skuName string = 'Standard_LRS'

@description('Account kind')
param kind string = 'StorageV2'

@description('Principal ID for GitHub Actions federated identity')
param githubPrincipalId string = ''

@description('Principal ID for Azure AI Foundry Project managed identity')
param foundryPrincipalId string = ''

@description('Optional agent runtime Identity (if your app/agent itself writes to Blob)')
param agentPrincipalId string = ''

@description('Optional blob containers to create')
param containers array = [
  'agents'
]

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: skuName
  }
  kind: kind
  properties: {
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
  }
}

@batchSize(1)
resource blobContainers 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = [for c in containers: {
  name: '${storageAccount.name}/default/${c}'
  properties: {
    publicAccess: 'None'
  }
}]

//
// --- RBAC ROLE ASSIGNMENTS ---
//

// Built‑in role IDs
var roleBlobReaderId      = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '2a2b9908-6ea1-4ae2-8e65-a410df84e7d1') // Storage Blob Data Reader
var roleBlobContributorId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ba92f5b4-2d11-453d-a403-e96b0029c9fe') // Storage Blob Data Contributor

// CI/CD → needs write access to upload agent files
resource githubBlobContrib 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!empty(githubPrincipalId)) {
  name: guid(storageAccount.id, githubPrincipalId, 'github-blob-contrib')
  scope: storageAccount
  properties: {
    roleDefinitionId: roleBlobContributorId
    principalId: githubPrincipalId
    principalType: 'ServicePrincipal'
  }
}

// Foundry Project Identity → needs read access for agent runtime + file search
resource foundryBlobReader 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!empty(foundryPrincipalId)) {
  name: guid(storageAccount.id, foundryPrincipalId, 'foundry-blob-reader')
  scope: storageAccount
  properties: {
    roleDefinitionId: roleBlobReaderId
    principalId: foundryPrincipalId
    principalType: 'ServicePrincipal'
  }
}

// If your agent runtime MI must write logs or generate files
resource agentBlobContrib 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!empty(agentPrincipalId)) {
  name: guid(storageAccount.id, agentPrincipalId, 'agent-blob-contrib')
  scope: storageAccount
  properties: {
    roleDefinitionId: roleBlobContributorId
    principalId: agentPrincipalId
    principalType: 'ServicePrincipal'
  }
}

output storageAccountId string = storageAccount.id
output storageAccountName string = storageAccount.name
