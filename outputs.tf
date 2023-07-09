output "fabric_inventory" {
  description = "Fabric Membership Identifiers: Fabric => Inventory => Fabric Membership"
  value = {
    fabric_membership = {
      for v in sort(keys(aci_rest_managed.fabric_membership)
      ) : v => aci_rest_managed.fabric_membership[v].id
    }
  }
}

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

output "vpc_domains" {
  description = "VPC Domain Identifiers: Fabric => Access Policies => Policies => Switch => Virtual Port Channel default"
  value = {
    for v in sort(keys(aci_vpc_explicit_protection_group.vpc_domains)
    ) : v => aci_vpc_explicit_protection_group.vpc_domains[v].id
  }
}
