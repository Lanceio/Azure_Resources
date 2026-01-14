
targetScope = 'resourceGroup'

@description('Name of the Azure AI Service (Cognitive Services) account')
param aifName string

@description('Azure location')
param location string

@description('Kind of the AI resource (e.g., "AIServices", "CognitiveServices", "OpenAI")')
param kind string = 'AIServices'

@description('Public network access setting: "Enabled" or "Disabled"')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Enabled'

@description('SKU for the Cognitive Services account')
@allowed([
  'S0'
  // add other allowed SKUs if needed
])
param skuName string = 'S0'

resource aiFoundry 'Microsoft.CognitiveServices/accounts@2023-05-01' = {
  name: aifName
  location: location
  kind: kind
  sku: {
    name: skuName
  }
  properties: {
    // Required/important: explicitly set public network access
    publicNetworkAccess: publicNetworkAccess

    // Optional: Add network ACLs when using 'Disabled' + Private Endpoints
    // networkAcls: {
    //   defaultAction: 'Deny'
    //   ipRules: [
    //     // { value: 'x.x.x.x' }
    //   ]
    //   virtualNetworkRules: [
    //     // { id: '/subscriptions/<subId>/resourceGroups/<rg>/providers/Microsoft.Network/virtualNetworks/<vnet>/subnets/<subnet>' }
    //   ]
    // }

    // Optional: apiProperties for service-specific configuration
    apiProperties: {
      // Add specific API properties if needed; leave empty otherwise
    }

    // Optional (if you need customer-managed keys, identities, private endpoints, etc.)
    // encryption: { keySource: 'Microsoft.KeyVault', keyVaultProperties: { keyName: '', keyVersion: '', keyVaultUri: '' } }
  }
}


