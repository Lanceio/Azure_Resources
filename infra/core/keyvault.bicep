
@description('Name of the Key Vault')
param keyVaultName string

@description('Azure location')
param location string

@description('Tenant ID for the directory')
param tenantId string

@description('Public network access setting for Key Vault')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Enabled'

resource keyVault 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: keyVaultName
  location: location
  properties: {
    tenantId: tenantId
    sku: {
      family: 'A'
      name: 'standard'
    }
    enablePurgeProtection: true
    publicNetworkAccess: publicNetworkAccess
    enabledForDeployment: true
    enabledForDiskEncryption: true
    enabledForTemplateDeployment: true
    enableRbacAuthorization: true
  }
}


