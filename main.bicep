@sys.description('The Web App.')
@minLength(3)
@maxLength(40)
param appServiceFEAppName string = 'Yousif-assignment-app-bicep-FE'

@sys.description('The App Service.')
@minLength(3)
@maxLength(40)
param appServiceFEPlanName string = 'Yousif-assignment-asp-bicep-FE'

@sys.description('The Web App.')
@minLength(3)
@maxLength(40)
param appServiceBEAppName string = 'Yousif-assignment-app-bicep-BE'

@sys.description('The App Service.')
@minLength(3)
@maxLength(40)
param appServiceBEPlanName string = 'Yousif-assignment-asp-bicep-BE'

@sys.description('The Storage.')
@minLength(3)
@maxLength(40)
param storageAccountName string = 'YousifStorage'
@allowed([
  'nonprod'
  'prod'
])
param environmentType string = 'nonprod'
param location string = resourceGroup().location

@secure()
param dbhost string
@secure()
param dbuser string
@secure()
param dbpass string
@secure()
param dbname string

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

module appServiceFE 'module/modules.bicep' = {
  name: 'appServiceFE'
  params: {
    location: location
    appServiceAppName: appServiceFEAppName
    appServicePlanName: appServiceFEPlanName
    environmentType: environmentType
    dbhost: dbhost
    dbuser: dbuser
    dbpass: dbpass
    dbname: dbname
  }
}

module appServiceBE 'module/modules.bicep' = {
  name: 'appServiceBE'
  params: {
    location: location
    appServiceAppName: appServiceBEAppName
    appServicePlanName: appServiceBEPlanName
    environmentType: environmentType
    dbhost: dbhost
    dbuser: dbuser
    dbpass: dbpass
    dbname: dbname
  }
}

output appServiceFEAppHostName string = appServiceFE.outputs.appServiceAppHostName
output appServiceBEAppHostName string = appServiceBE.outputs.appServiceAppHostName
