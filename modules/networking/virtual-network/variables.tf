variable "resource_group_name" {
  type        = string
  description = "The name of the resource group for this resource."
}

variable "location" {
  type        = string
  description = "The location of the resource."
}

variable "resource_instance_count" {
  type        = string
  description = "The instance of resource type in the resource group if more that one resource exists in the same resource group. "
}

variable "resource_type_abbrv" {
  type        = string
  description = "The resource type abbreviation."
  default     = "vnet"
}

variable "environment" {
  type        = string
  description = "The environment the resource will be deployed to."
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
  default     = {}
}

variable "solution_name" {
  type        = string
  description = "solution name for azure data bricks."
}

# vnet variables
variable "address_space" {
  type        = list(string)
  description = "The address space that is used the virtual network. You can supply more than one address space."
}

variable "dns_servers" {
  type        = list(string)
  description = "If applicable, a list of custom DNS servers to use inside your virtual network.  Unset will use default Azure-provided resolver"
  default     = null
}

variable "ddos_protection_plan" {
  description = "ddos protection plan object."
  type = object({
    id     = optional(string) # The ID of DDoS Protection Plan.
    enable = optional(bool)   # Enable/disable DDoS Protection Plan on Virtual Network.
  })
  default = null
}

variable "encryption" {
  description = "encryption object."
  type = object({
    enforcment = optional(string) # Specifies if the encrypted Virtual Network allows VM that does not support encryption. Possible values are DropUnencrypted and AllowUnencrypted.
  })
  default = null
}

variable "vnet_peers" {
  description = "list object of vnets to peer."
  type = list(object({
    name                         = optional(string)      # The name of the virtual network peering. Changing this forces a new resource to be created.
    remote_virtual_network_id    = optional(string)      # The full Azure resource ID of the remote virtual network. Changing this forces a new resource to be created.
    allow_virtual_network_access = optional(bool, true)  # Controls if the VMs in the remote virtual network can access VMs in the local virtual network. Defaults to true.
    allow_forwarded_traffic      = optional(bool, true)  # Controls if forwarded traffic from VMs in the remote virtual network is allowed.
    allow_gateway_transit        = optional(bool, false) # Controls gatewayLinks can be used in the remote virtual network’s link to the local virtual network. Defaults to false.
    use_remote_gateways          = optional(bool, false) #  Controls if remote gateways can be used on the local virtual network. If the flag is set to true, and allow_gateway_transit on the remote peering is also true, virtual network will use gateways of remote virtual network for transit. Only one peering can have this flag set to true. This flag cannot be set if virtual network already has a gateway. Defaults to false.
  }))
  default = []
}


# Subnet variables
variable "subnets" {
  description = "list of objects for subnets"
  type = list(object({
    subnet_name                                   = optional(string)             # The name of the subnet. Changing this forces a new resource to be created.
    address_prefixes                              = optional(list(string))       # The address prefixes to use for the subnet.
    private_endpoint_network_policies_enabled     = optional(string, "Disabled") #  Enable or Disable network policies for the private endpoint on the subnet. Setting this to true will Enable the policy and setting this to false will Disable the policy.
    private_link_service_network_policies_enabled = optional(bool, false)        # Enable or Disable network policies for the private link service on the subnet. Setting this to true will Enable the policy and setting this to false will Disable the policy.
    service_endpoints                             = optional(list(string), [])   #  The list of Service endpoints to associate with the subnet. Possible values include: Microsoft.AzureActiveDirectory, Microsoft.AzureCosmosDB, Microsoft.ContainerRegistry, Microsoft.EventHub, Microsoft.KeyVault, Microsoft.ServiceBus, Microsoft.Sql, Microsoft.Storage, Microsoft.Storage.Global and Microsoft.Web.
    delegation = optional(object({
      name = optional(string) #  A name for this delegation.
      service_delegation = optional(object({
        service_name = optional(string)             #  The name of service to delegate to. Possible values are GitHub.Network/networkSettings, Microsoft.ApiManagement/service, Microsoft.Apollo/npu, Microsoft.App/environments, Microsoft.App/testClients, Microsoft.AVS/PrivateClouds, Microsoft.AzureCosmosDB/clusters, Microsoft.BareMetal/AzureHostedService, Microsoft.BareMetal/AzureHPC, Microsoft.BareMetal/AzurePaymentHSM, Microsoft.BareMetal/AzureVMware, Microsoft.BareMetal/CrayServers, Microsoft.BareMetal/MonitoringServers, Microsoft.Batch/batchAccounts, Microsoft.CloudTest/hostedpools, Microsoft.CloudTest/images, Microsoft.CloudTest/pools, Microsoft.Codespaces/plans, Microsoft.ContainerInstance/containerGroups, Microsoft.ContainerService/managedClusters, Microsoft.ContainerService/TestClients, Microsoft.Databricks/workspaces, Microsoft.DBforMySQL/flexibleServers, Microsoft.DBforMySQL/servers, Microsoft.DBforMySQL/serversv2, Microsoft.DBforPostgreSQL/flexibleServers, Microsoft.DBforPostgreSQL/serversv2, Microsoft.DBforPostgreSQL/singleServers, Microsoft.DelegatedNetwork/controller, Microsoft.DevCenter/networkConnection, Microsoft.DocumentDB/cassandraClusters, Microsoft.Fidalgo/networkSettings, Microsoft.HardwareSecurityModules/dedicatedHSMs, Microsoft.Kusto/clusters, Microsoft.LabServices/labplans, Microsoft.Logic/integrationServiceEnvironments, Microsoft.MachineLearningServices/workspaces, Microsoft.Netapp/volumes, Microsoft.Network/dnsResolvers, Microsoft.Network/fpgaNetworkInterfaces, Microsoft.Network/networkWatchers., Microsoft.Network/virtualNetworkGateways, Microsoft.Orbital/orbitalGateways, Microsoft.PowerPlatform/enterprisePolicies, Microsoft.PowerPlatform/vnetaccesslinks, Microsoft.ServiceFabricMesh/networks, Microsoft.ServiceNetworking/trafficControllers, Microsoft.Singularity/accounts/networks, Microsoft.Singularity/accounts/npu, Microsoft.Sql/managedInstances, Microsoft.Sql/managedInstancesOnebox, Microsoft.Sql/managedInstancesStage, Microsoft.Sql/managedInstancesTest, Microsoft.StoragePool/diskPools, Microsoft.StreamAnalytics/streamingJobs, Microsoft.Synapse/workspaces, Microsoft.Web/hostingEnvironments, Microsoft.Web/serverFarms, NGINX.NGINXPLUS/nginxDeployments, PaloAltoNetworks.Cloudngfw/firewalls, and Qumulo.Storage/fileSystems.
        actions      = optional(list(string), null) #  A list of Actions which should be delegated. This list is specific to the service to delegate to. Possible values are Microsoft.Network/networkinterfaces/*, Microsoft.Network/publicIPAddresses/join/action, Microsoft.Network/publicIPAddresses/read, Microsoft.Network/virtualNetworks/read, Microsoft.Network/virtualNetworks/subnets/action, Microsoft.Network/virtualNetworks/subnets/join/action, Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action, and Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action.
      }))
    }), null)
  }))
}

variable "network_security_groups" {
  description = "list of object for network security groups."
  type = list(object({
    name = string # Specifies the name of the network security group. Changing this forces a new resource to be created.
    network_security_rules = optional(list(object({
      name                         = string                 # The name of the security rule. This needs to be unique across all Rules in the Network Security Group. Changing this forces a new resource to be created.
      priority                     = optional(number)       # Network protocol this rule applies to. Possible values include Tcp, Udp, Icmp, Esp, Ah or * (which matches all).
      direction                    = optional(string)       # The direction specifies if rule will be evaluated on incoming or outgoing traffic. Possible values are Inbound and Outbound.
      access                       = optional(string)       # Specifies whether network traffic is allowed or denied. Possible values are Allow and Deny.
      protocol                     = optional(string)       # Network protocol this rule applies to. Possible values include Tcp, Udp, Icmp, Esp, Ah or * (which matches all).
      source_port_range            = optional(string)       #  Source Port or Range. Integer or range between 0 and 65535 or * to match any. This is required if source_port_ranges is not specified.
      source_port_ranges           = optional(list(string)) # List of source ports or port ranges. This is required if source_port_range is not specified.
      destination_port_range       = optional(string)       # Destination Port or Range. Integer or range between 0 and 65535 or * to match any. This is required if destination_port_ranges is not specified.
      destination_port_ranges      = optional(list(string)) # List of destination ports or port ranges. This is required if destination_port_range is not specified.
      source_address_prefix        = optional(string)       # CIDR or source IP range or * to match any IP. Tags such as VirtualNetwork, AzureLoadBalancer and Internet can also be used. This is required if source_address_prefixes is not specified.
      source_address_prefixes      = optional(list(string)) #  List of source address prefixes. Tags may not be used. This is required if source_address_prefix is not specified.
      destination_address_prefix   = optional(string)       # CIDR or destination IP range or * to match any IP. Tags such as VirtualNetwork, AzureLoadBalancer and Internet can also be used. Besides, it also supports all available Service Tags like ‘Sql.WestEurope‘, ‘Storage.EastUS‘, etc. You can list the available service tags with the CLI: shell az network list-service-tags --location westcentralus. For further information please see Azure CLI - az network list-service-tags. This is required if destination_address_prefixes is not specified.
      destination_address_prefixes = optional(list(string)) # List of destination address prefixes. Tags may not be used. This is required if destination_address_prefix is not specified.
    })), [])
  }))
  default = []
}

variable "subnet_nsg_association" {
  description = "list of objects for subnet nsg association."
  type = list(object({
    association_name = string
    subnet_name      = optional(string) # The name of the Subnet. Changing this forces a new resource to be created.
    nsg_name         = optional(string) # The name of the Network Security Group which should be associated with the Subnet. Changing this forces a new resource to be created.
  }))
  default = []
}

# route table variables
variable "route_tables" {
  description = "list of objects for route tables."
  type = list(object({
    name = string # The name of the route table. Changing this forces a new resource to be created.
    routes = optional(list(object({
      name                   = string           # The name of the route. Changing this forces a new resource to be created.
      address_prefix         = optional(string) # The destination to which the route applies. Can be CIDR (such as 10.1.0.0/16) or Azure Service Tag (such as ApiManagement, AzureBackup or AzureMonitor) format.
      next_hop_type          = optional(string) # The type of Azure hop the packet should be sent to. Possible values are VirtualNetworkGateway, VnetLocal, Internet, VirtualAppliance and None.
      next_hop_in_ip_address = optional(string) # Contains the IP address packets should be forwarded to. Next hop values are only allowed in routes where the next hop type is VirtualAppliance.
    })))
  }))
  default = []
}

variable "subnet_rt_association" {
  description = "list of objects for subnet route table association."
  type = list(object({
    association_name = string
    subnet_name      = optional(string) # The ID of the Route Table which should be associated with the Subnet. Changing this forces a new resource to be created.
    route_table_name = optional(string) # The ID of the Subnet. Changing this forces a new resource to be created.
  }))
  default = []
}