@sys.description('The Web App.')
@minLength(3)
@maxLength(40)
param appServiceAppName string = 'Yousif-assignment-app-bicep'
@sys.description('The App Service.')
@minLength(3)
@maxLength(40)
param appServicePlanName string = 'Yousif-assignment-asp-bicep'
@sys.description('The Storage.')
@minLength(3)
@maxLength(40)

param storageAccountName string = 'jseijasstorage'
@allowed([
  'nonprod'
  'prod'
])


param environmentType string = 'nonprod'
param location string = resourceGroup().location

var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountSkuName
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

module appService 'module/moudles.bicep' = {
  name: 'appService'
  params: {
    location: location
    appServiceAppName: appServiceAppName
    appServicePlanName: appServicePlanName
    environmentType: environmentType
  }
}

output appServiceAppHostName string = appService.outputs.appServiceAppHostName
