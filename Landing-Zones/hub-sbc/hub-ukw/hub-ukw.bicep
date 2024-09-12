targetScope = 'subscription'
// =====================//
// Pipeline Parameters //
// =====================//
@description('Mandatory. Environment where the resources to be deployed.')
param environment string =''

@description('Mandatory. SubscriptionId of the resources to be deployed.')
param subscriptionId string =''

@description('Mandatory. location of the resources to be deployed.')
param location string =''
// ========== //
// Parameters //
// ========== //
@description('Mandatory. An array of resource groups to be deployed.')
param resourceGroups array = [
  {
    resourceGroupName: 'network-${environment}-rg-001'
    location: location
  }
  {
    resourceGroupName: 'artifact-${environment}-rg-001'
    location: location
  }
]

@description('Mandatory. An array of route tables to be deployed.')
param routeTables array = [
  {
    routetableName: 'network-${environment}-rt-01'
    resourceGroupName: resourceGroups[0].resourceGroupName
    location: resourceGroups[0].location
    routes: [
      {
        name: 'test-route'
        properties: {
          addressPrefix: '10.0.0.0/24'
          hasBgpOverride: false
          nextHopIpAddress: '10.0.0.5'
          nextHopType: 'VirtualAppliance'
        }
      }
    ]
  }
  {
    routetableName: 'network-${environment}-rt-02'
    resourceGroupName: resourceGroups[0].resourceGroupName
    location: resourceGroups[0].location
    routes: [
      {
        name: 'test-route'
        properties: {
          addressPrefix: '10.0.0.0/24'
          hasBgpOverride: false
          nextHopIpAddress: '10.0.0.5'
          nextHopType: 'VirtualAppliance'
        }
      }
    ]
  }
]

@description('Mandatory. An array of route tables to be deployed.')
param networkSecurityGroups array = [
  {
    nsgName: 'network-${environment}-nsg-01'
    resourceGroupName: resourceGroups[0].resourceGroupName
    location: resourceGroups[0].location
    securityRules: [
      {
        name: 'Specific'
        properties: {
          access: 'Allow'
          description: 'Tests specific IPs and ports'
          destinationAddressPrefix: '*'
          destinationPortRange: '8080'
          direction: 'Inbound'
          priority: 100
          protocol: '*'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
        }
      }
      {
        name: 'Ranges'
        properties: {
          access: 'Allow'
          description: 'Tests Ranges'
          destinationAddressPrefixes: [
            '10.5.0.0/16'
            '10.6.0.0/16'
          ]
          destinationPortRanges: [
            '90'
            '91'
          ]
          direction: 'Inbound'
          priority: 101
          protocol: '*'
          sourceAddressPrefixes: [
            '10.0.0.0/16'
            '10.4.0.0/16'
          ]
          sourcePortRanges: [
            '80'
            '81'
          ]
        }
      }
    ]
  }
  {
    nsgName: 'network-${environment}-nsg-02'
    resourceGroupName: resourceGroups[0].resourceGroupName
    location: resourceGroups[0].location
    securityRules: [
      {
        name: 'Specific'
        properties: {
          access: 'Allow'
          description: 'Tests specific IPs and ports'
          destinationAddressPrefix: '*'
          destinationPortRange: '8080'
          direction: 'Inbound'
          priority: 100
          protocol: '*'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
        }
      }
      {
        name: 'Ranges'
        properties: {
          access: 'Allow'
          description: 'Tests Ranges'
          destinationAddressPrefixes: [
            '10.5.0.0/16'
            '10.6.0.0/16'
          ]
          destinationPortRanges: [
            '90'
            '91'
          ]
          direction: 'Inbound'
          priority: 101
          protocol: '*'
          sourceAddressPrefixes: [
            '10.0.0.0/16'
            '10.4.0.0/16'
          ]
          sourcePortRanges: [
            '80'
            '81'
          ]
        }
      }
    ]
  }
]

@description('Mandatory. An array of virtual network to be deployed.')
param virtualNetworks array = [
  {
    virtualNetworkName: 'network-${environment}-vnet-001'
    resourceGroupName: resourceGroups[0].resourceGroupName
    location: resourceGroups[0].location
    addressPrefixes: [ '10.4.0.0/16', '10.5.0.0/16', '10.6.0.0/16' ]
    dnsServers: ['16.5.6.7']
    subnets: [
      {
        name: 'subnet01'
        addressPrefix: '10.4.1.0/28'
        delegations: [ {
            name: 'netappDel'
            properties: {
              serviceName: 'Microsoft.Netapp/volumes'
            }
          } ]
        //natGatewayId: '/subscriptions/87c08485-0b8f-411e-a493-684401dc0a81/resourceGroups/network-${environment}-rg-001/providers/Microsoft.Network/natGateways/test-NAT-gw-001'
        //networkSecurityGroupId: '/subscriptions/87c08485-0b8f-411e-a493-684401dc0a81/resourceGroups/network-${environment}-rg-001/providers/Microsoft.Network/networkSecurityGroups/test-nsg-001'
        privateEndpointNetworkPolicies: [ 'Enabled' ]
        routeTableName: 'network-${environment}-rt-01'
        networkSecurityGroupName: 'network-${environment}-nsg-01'
        serviceEndpoints: [ {
            service: 'Microsoft.Storage'
          }
          {
            service: 'Microsoft.Sql'
          } ]
      }
      {
        name: 'subnet02'
        addressPrefix: '10.4.1.32/28'
        delegations: [ {
            name: 'netappDel'
            properties: {
              serviceName: 'Microsoft.Netapp/volumes'
            }
          } ]
        //natGatewayId: '/subscriptions/87c08485-0b8f-411e-a493-684401dc0a81/resourceGroups/network-${environment}-rg-001/providers/Microsoft.Network/natGateways/test-NAT-gw-001'
        //networkSecurityGroupId: '/subscriptions/87c08485-0b8f-411e-a493-684401dc0a81/resourceGroups/network-${environment}-rg-001/providers/Microsoft.Network/networkSecurityGroups/test-nsg-001'
        privateEndpointNetworkPolicies: [ 'Enabled' ]
        routeTableName: 'network-${environment}-rt-02'
        networkSecurityGroupName: 'network-${environment}-nsg-02'
        serviceEndpoints: [ {
            service: 'Microsoft.Storage'
          }
          {
            service: 'Microsoft.Sql'
          } ]
      }
    ]
  }
]

@description('Madatory. An array of storage accounts to be deployed')
param storageAccounts array = [
  {
    storageAccountName: 'artifacts${replace(environment, '-', '')}sa001'
    resourceGroupName: resourceGroups[1].resourceGroupName
    location: resourceGroups[1].location
    storageAccountSku: 'Standard_LRS'
    allowBlobPublicAccess: false
    requireInfrastructureEncryption: true
    largeFileSharesState: 'Enabled'
    enableHierarchicalNamespace: true
    enableSftp: true
    enableNfsV3: false
    blobServices: {
      containers: [
        {
          name: 'artifacts${replace('${environment}', '-', '')}container001'
          publicAccess: 'None'
        }
      ]
    }
  }
]

// =============== //
// Resource Group //
// =============== //

module resourceGroup '../../../components/resourcegroup/main.bicep'/*'br:sreelekshmiashaji@dev.azure.com/sreelekshmiashaji/bicep-landingzones/bicep-componentscomponents/resourcegroup/main.bicep:1.0.0'*/ = [for rg in resourceGroups: {
  name: rg.resourceGroupName
  params: {
    resourceGroupName: rg.resourceGroupName
    location: rg.location
  }
}]

// =============== //
//   Route Table   //
// =============== //

module routeTable '../../../components/routetable/main.bicep' = [for route in routeTables: {
  scope: az.resourceGroup(route.resourceGroupName)
  name: route.routetableName
  params: {
    name: route.routetableName
    location: route.location
    routes: route.routes
    disableBgpRoutePropagation: false
  }
  dependsOn: [ resourceGroup ]
}]


// =========================== //
//   Network Security Group   //
// ========================== //

module networkSecurityGroup '../../../components/networksecuritygroup/main.bicep' = [for networkSecurityGroup in networkSecurityGroups: {
  scope: az.resourceGroup(networkSecurityGroup.resourceGroupName)
  name: networkSecurityGroup.nsgName
  params: {
  name: networkSecurityGroup.nsgName
  location: networkSecurityGroup.location
  securityRules: networkSecurityGroup.securityRules
  }
  dependsOn: [ routeTable ]
}]

// =============== //
// Virtual Network   //
// =============== //

module virtualNetwork '../../../components/virtualnetwork/main.bicep' =[for vnet in virtualNetworks  : {
  scope: az.resourceGroup(vnet.resourceGroupName)
  name: vnet.virtualNetworkName
  params: {
    name: vnet.virtualNetworkName
    location: vnet.location
    addressPrefixes: vnet.addressPrefixes
    dnsServers: vnet.dnsServers
    lock: ''
    subnets:[ for subnet in vnet.subnets :{
        name: subnet.name
        addressPrefix: subnet.addressPrefix
        delegations: subnet.delegations
        privateEndpointNetworkPolicies: subnet.privateEndpointNetworkPolicies
        routeTableId: '/subscriptions/${subscriptionId}/resourceGroups/${resourceGroups[0].resourceGroupName}/providers/Microsoft.Network/routeTables/${subnet.routeTableName}'
        networkSecurityGroupId: '/subscriptions/${subscriptionId}/resourceGroups/${resourceGroups[0].resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/${subnet.networkSecurityGroupName}'
        serviceEndpoints: subnet.serviceEndpoints 
      }]
  }
  dependsOn: [ networkSecurityGroup ]
}]

// =============== //
// Storage Account //
// =============== //

module storageAccount '../../../components/storageaccount/main.bicep' = [for sa in storageAccounts: {
  scope:  az.resourceGroup(sa.resourceGroupName)
  name: sa.storageAccountName
  params: {
    name: sa.storageAccountName
    location: sa.location
    storageAccountSku: sa.storageAccountSku
    allowBlobPublicAccess: sa.allowBlobPublicAccess
    requireInfrastructureEncryption: sa.requireInfrastructureEncryption
    largeFileSharesState: sa.largeFileSharesState
    enableHierarchicalNamespace:sa.enableHierarchicalNamespace
    enableSftp: sa.enableSftp
    enableNfsV3: sa.enableNfsV3
    lock: ''
    blobServices: sa.blobServices
  }
  dependsOn: [ resourceGroup ]
}]
