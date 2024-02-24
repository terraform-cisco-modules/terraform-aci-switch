/*_____________________________________________________________________________________________________________________

Fabric Inventory — Outputs
_______________________________________________________________________________________________________________________
*/
output "fabric_inventory" {
  description = "Fabric Membership Identifiers: Fabric => Inventory => Fabric Membership"
  value = {
    fabric_membership = {
      for v in sort(keys(aci_rest_managed.fabric_membership)
      ) : v => aci_rest_managed.fabric_membership[v].id
    }
  }
}

/*_____________________________________________________________________________________________________________________

Interface Profiles — Outputs
_______________________________________________________________________________________________________________________
*/
output "interface_profiles" {
  description = <<EOF
    Interface Profile Identifiers
      interfaces:
        leaf_interface_profiles:  Fabric => Access Policies => Interfaces => Leaf Interfaces => Profiles
        spine_interface_profiles: Fabric => Access Policies => Interfaces => Spine Interfaces => Profiles
  EOF
  value = {
    leaf_interface_profiles = {
      for v in sort(keys(aci_leaf_profile.map)) : v => aci_leaf_profile.map[v].id
    }
    spine_interface_profiles = {
      for v in sort(keys(aci_spine_profile.map)) : v => aci_spine_profile.map[v].id
    }
  }
}

/*_____________________________________________________________________________________________________________________

Static Node Mgmt Addresses — Outputs
_______________________________________________________________________________________________________________________
*/
output "static_node_mgmt_address" {
  description = "Static Node Management addresses: Tenants: {mgmt} => Node Management Addresses => Static Node Management Addresses"
  value       = { for v in sort(keys(aci_static_node_mgmt_address.map)) : v => aci_static_node_mgmt_address.map[v].id }
}

/*_____________________________________________________________________________________________________________________

Switch Profiles — Outputs
_______________________________________________________________________________________________________________________
*/
output "switches" {
  description = <<EOF
    Switch Identifiers
      switches:
        leaf_profiles:  Fabric => Access Policies => Switches => Leaf Switches => Profiles
        spine_profiles: Fabric => Access Policies => Switches => Spine Switches => Profiles
  EOF
  value = {
    leaf_profiles = {
      for v in sort(keys(aci_leaf_profile.map)) : v => aci_leaf_profile.map[v].id
    }
    spine_profiles = {
      for v in sort(keys(aci_spine_profile.map)) : v => aci_spine_profile.map[v].id
    }
  }
}

/*_____________________________________________________________________________________________________________________

VPC Domains — Outputs
_______________________________________________________________________________________________________________________
*/
output "vpc_domains" {
  description = "VPC Domain Identifiers: Fabric => Access Policies => Policies => Switch => Virtual Port Channel default"
  value = {
    for v in sort(keys(aci_vpc_explicit_protection_group.vpc_domains)
    ) : v => aci_vpc_explicit_protection_group.vpc_domains[v].id
  }
}
