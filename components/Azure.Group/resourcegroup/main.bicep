@minLength(8)
@maxLength(24)
@description('Provide a name for the resource group. The name must be unique across an Azure subscription')
param resourceGroupName string = 'test-rg-uks-001'

@description('Provide the location where the resource group should be deployed')
param location string = 'uksouth'

targetScope = 'subscription'
resource rg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: resourceGroupName
  location: location
}
@description('The name of the resource group which was created.')
output resourceGroupName string = rg.name
@description('The resource id of the resource group which was created')
output resourceId string = rg.id
