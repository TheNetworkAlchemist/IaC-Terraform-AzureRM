# IaC-Terraform-AzureRM
Deploying Infrastructure as Code leveraging Terraform and AzureRM

## Build Azure Site-to-Multi-Site VPN
This will build the following components:
* Dynamic Public IP
* Local Network Gateway
* Virtual Network Gateway
* Virtual Network Gateway Connection

# To Do List
* Create *sample-variables.tf*

# Assumptions
* Existing __*Resource Group*__
* Existing default __*Virtual Network*__
* Existing __*GatewaySubnet*__
     * *may revise to create on-demand ~ TBD*
* Ports are open to the on-prem VPN terminating device
     * __UDP Port Number = 500__ → Used by IKE (IPSec control path)
     * __UDP Port Number = 4500__ → Used by NAT-T (IPsec NAT traversal)

# Usage
## Variables
See *sample-variables.tf*

Edit file contents and rename as __*variables.tf*__

## Initiate Terraform and download AzureRM Provider
```terraform
terrform init
```

### Terraform Plan
```terraform
terrform plan
```

### Terraform Apply
```terraform
terrform apply
```

#### Wait
Virtual Network Gateways are expected to take __20-60__ minutes to provision.  Typical duration is __25__ minutes


### Identify Azure Public Cloud IP
__*pub_ip*__ is dynamically assigned after being provisioned.  Use this IP to complete the on-prem VPN configuration.  


### Terraform Recycle all Components
```terraform
terrform destroy
```

#### Wait
Virtual Network Gateways are expected to take __5-15__ minutes to deprovision.  Typical duration is __8__ minutes


# VPN Phase 1 and Phase 2 Settings
## Phase 1/Main Mode:
     IKE encryption algorithm
     IKE hashing algorithm
     IKE Diffie-Hellman group
     IKE SA lifetime (seconds)
     IKE SA data size (Kilobytes) 

     /Data/IKE_ENCRYPTION_1 = aes256
     /Data/IKE_INTEGRITY_1  = sha1
     /Data/IKE_DHGROUP_1    = 2
     /Data/IKE_SALIFETIME_1 = 3600
 

## Phase 2/Quick Mode:
     IPsec encryption algorithm
     IPsec hashing algorithm
     PFS Group (Perfect Forward Secrecy)
     IPsec SA (QMSA) lifetime (seconds)
     IPsec SA (QMSA) lifetime (kilobytes) 

     /Data/IPsec_ENCRYPTION_1 	= aes256
     /Data/IPsec_INTEGRITY_1  	= sha1
     /Data/IPsec_PFSGROUP_1   	= None
     /Data/IPsec_SALIFETIME   	= 3600
     /Data/IPsec_KB_SALIFETIME     = 102400000


### Notes
* Azure Virtual Network Gateways do not support IKEv2 under the __*basic*__ SKU