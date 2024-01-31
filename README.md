<!-- BEGIN_TF_DOCS -->
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Developed by: Cisco](https://img.shields.io/badge/Developed%20by-Cisco-blue)](https://developer.cisco.com)

# Terraform ACI - Switch Configuration Module

A Terraform module to configure ACI Switch Configuration.

### NOTE: THIS MODULE IS DESIGNED TO BE CONSUMED USING "EASY ACI"

### A comprehensive example using this module is available below:

## [Easy ACI](https://github.com/terraform-cisco-modules/easy-aci)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.13.0 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | 2.13.0 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_switch"></a> [switch](#input\_switch) | Switch Model data. | `any` | n/a | yes |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_fabric_inventory"></a> [fabric\_inventory](#output\_fabric\_inventory) | Fabric Membership Identifiers: Fabric => Inventory => Fabric Membership |
| <a name="output_interface_profiles"></a> [interface\_profiles](#output\_interface\_profiles) | Interface Profile Identifiers<br>      interfaces:<br>        leaf\_interface\_profiles:  Fabric => Access Policies => Interfaces => Leaf Interfaces => Profiles<br>        spine\_interface\_profiles: Fabric => Access Policies => Interfaces => Spine Interfaces => Profiles |
| <a name="output_static_node_mgmt_address"></a> [static\_node\_mgmt\_address](#output\_static\_node\_mgmt\_address) | Static Node Management addresses: Tenants: {mgmt} => Node Management Addresses => Static Node Management Addresses |
| <a name="output_switches"></a> [switches](#output\_switches) | Switch Identifiers<br>      switches:<br>        leaf\_profiles:  Fabric => Access Policies => Switches => Leaf Switches => Profiles<br>        spine\_profiles: Fabric => Access Policies => Switches => Spine Switches => Profiles |
| <a name="output_vpc_domains"></a> [vpc\_domains](#output\_vpc\_domains) | VPC Domain Identifiers: Fabric => Access Policies => Policies => Switch => Virtual Port Channel default |
## Resources

| Name | Type |
|------|------|
| [aci_access_port_block.leaf_port_blocks](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/access_port_block) | resource |
| [aci_access_port_selector.map](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/access_port_selector) | resource |
| [aci_access_sub_port_block.leaf_port_subblocks](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/access_sub_port_block) | resource |
| [aci_leaf_interface_profile.map](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/leaf_interface_profile) | resource |
| [aci_leaf_profile.map](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/leaf_profile) | resource |
| [aci_leaf_selector.map](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/leaf_selector) | resource |
| [aci_node_block.leaf_profile_blocks](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/node_block) | resource |
| [aci_rest_managed.fabric_membership](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spine_interface_policy_group](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spine_interface_selectors](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spine_profile_node_blocks](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.virtual_port_channel_default](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_spine_interface_profile.map](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/spine_interface_profile) | resource |
| [aci_spine_profile.map](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/spine_profile) | resource |
| [aci_spine_switch_association.map](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/spine_switch_association) | resource |
| [aci_static_node_mgmt_address.map](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/static_node_mgmt_address) | resource |
| [aci_vpc_explicit_protection_group.vpc_domains](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/vpc_explicit_protection_group) | resource |
<!-- END_TF_DOCS -->