
targetScope = 'resourceGroup'

@description('Name of the App Configuration resource')
param appConfigName string

@description('Azure location')
param location string

@description('Tier (free=Developer, standard=Production). Default: free')
@allowed([
  'free'      // Developer tier
  'developer'  // Production tier
])
param tier string = 'developer'

resource appConfig 'Microsoft.AppConfiguration/configurationStores@2023-03-01' = {
  name: appConfigName
  location: location
  sku: {
    name: tier
  }
  // Optional properties (enable only if you use private endpoints or customer-managed keys)
  // properties: {
  //   publicNetworkAccess: 'Enabled'
  // }
}

output appConfigEndpoint string = appConfig.properties.endpoint
