@description('Required. Name given for the hub route table.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. An Array of Routes to be established within the hub route table.')
param routes array = []

@description('Optional. Switch to disable BGP route propagation.')
param disableBgpRoutePropagation bool = false

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource routeTable 'Microsoft.Network/routeTables@2021-08-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    routes: routes
    disableBgpRoutePropagation: disableBgpRoutePropagation
  }
}

resource routeTable_lock 'Microsoft.Authorization/locks@2017-04-01' = if (!empty(lock)) {
  name: '${routeTable.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: routeTable
}


@description('The resource group the route table was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the route table.')
output name string = routeTable.name

@description('The resource ID of the route table.')
output resourceId string = routeTable.id

@description('The location the resource was deployed into.')
output location string = routeTable.location
