# Existing Infrastructure
# Reference Existing Subnet
data "azurerm_subnet" "gw_sub" {
  name                 = "GatewaySubnet"
  virtual_network_name = var.vnet
  resource_group_name  = var.resource_group
}

output "subnet_id" {
  value = data.azurerm_subnet.gw_sub.id
}


# Public IP - Dynamic
resource "azurerm_public_ip" "iac-pub-ip" {
  name                = var.pub_ip
  resource_group_name = var.resource_group
  location            = var.resource_group_location
  allocation_method   = "Dynamic"

  tags = {
    "network_infrastructure" = "iac_terraform"
  }
}

# Local Network Gateway
resource "azurerm_local_network_gateway" "iac-lngw" {
  name                = var.local_net_gw_name
  resource_group_name = var.resource_group
  location            = var.resource_group_location
  gateway_address     = var.local_net_gw_ip
  address_space       = var.on_prem_address_spaces

  tags = {
    "network_infrastructure" = "iac_terraform"
  }
}

# Virtual Network Gateway
# Provisioning Time: 30 min - 60 min
resource "azurerm_virtual_network_gateway" "iac-vngw" {
  name                = var.virtual_net_gw_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "VpnGw1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.iac-pub-ip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = data.azurerm_subnet.gw_sub.id
  }
  tags = {
    "network_infrastructure" = "iac_terraform"
  }
}


# Virtual Network Gateway Connection
resource "azurerm_virtual_network_gateway_connection" "iac-vngwc" {
  name                = var.virtual_net_gwc_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.iac-vngw.id
  local_network_gateway_id   = azurerm_local_network_gateway.iac-lngw.id

  shared_key = var.iac-vngwc-psk

  tags = {
    "network_infrastructure" = "iac_terraform"
  }
}

