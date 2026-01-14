
targetScope = 'resourceGroup'

@description('Name of the Application Insights resource')
param appInsightsName string

@description('Azure location')
param location string

@description('Application type (e.g., web, other)')
param applicationType string = 'web'

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  kind: applicationType
  properties: {
    Application_Type: applicationType
    Flow_Type: 'Bluefield'
    Request_Source: 'rest'
  }
}

