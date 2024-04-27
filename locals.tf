locals {
  defaults = yamldecode(file("${path.module}/defaults.yaml")).defaults.switch
  sprofile = local.defaults.switch_profiles
  vpcs     = local.defaults.vpc_domains
  npfx = {
    leaf  = merge(local.defaults.name_prefix.leaf, lookup(lookup(var.switch, "name_prefix", {}), "leaf", {}))
    spine = merge(local.defaults.name_prefix.spine, lookup(lookup(var.switch, "name_prefix", {}), "spine", {}))
  }
  nsfx = {
    leaf  = merge(local.defaults.name_prefix.leaf, lookup(lookup(var.switch, "name_prefix", {}), "leaf", {}))
    spine = merge(local.defaults.name_prefix.spine, lookup(lookup(var.switch, "name_prefix", {}), "spine", {}))
  }

  #__________________________________________________________
  #
  # Leaf Profiles Variables
  #__________________________________________________________

  switch_profiles = {
    for k, v in lookup(var.switch, "switch_profiles", []) : v.node_id => merge(local.sprofile, v, {
      inband_addressing = lookup(v, "inband_addressing", {})
      interfaces = [
        for i in lookup(v, "interfaces", []) : {
          description = lookup(i, "description", local.sprofile.interfaces.description)
          interface   = i.interface
          interface_description = lookup(
            i, "interface_description", local.sprofile.interfaces.interface_description
          )
          policy_group = lookup(i, "policy_group", local.sprofile.interfaces.policy_group)
          policy_group_type = lookup(
            i, "policy_group_type", local.sprofile.interfaces.policy_group_type
          )
          sub_port = lookup(i, "sub_port", local.sprofile.interfaces.sub_port)

        }
      ]
      name              = v.name
      node_id           = v.node_id
      ooband_addressing = lookup(v, "ooband_addressing", {})
      serial_number     = v.serial_number
    })
  }

  interface_selectors = {
    for i in flatten([
      for k, v in local.switch_profiles : [
        for s in v.interfaces : {
          description           = s.description
          interface_description = s.interface_description
          interface_name = coalesce(s.sub_port, false) == true && v.two_slot_leaf == true && length(
            regexall("^\\d$", element(split("/", s.interface), 1))) > 0 ? "Eth${element(split("/", s.interface), 0
              )}-00${element(split("/", s.interface), 1)}-${element(split("/", s.interface), 2
            )}" : coalesce(s.sub_port, false) == true && v.two_slot_leaf == true && length(
            regexall("^\\d{2}$", element(split("/", s.interface), 1))) > 0 ? "Eth${element(split("/", s.interface), 0
              )}-0${element(split("/", s.interface), 1)}-${element(split("/", s.interface), 2
            )}" : coalesce(s.sub_port, false) == true && v.two_slot_leaf == true && length(
            regexall("^\\d{3}$", element(split("/", s.interface), 1))) > 0 ? "Eth${element(split("/", s.interface), 0
              )}-${element(split("/", s.interface), 1)}-${element(split("/", s.interface), 2
            )}" : coalesce(s.sub_port, false) == false && v.two_slot_leaf == true && length(
            regexall("^\\d$", element(split("/", s.interface), 1))) > 0 ? "Eth${element(split("/", s.interface), 0
              )}-00${element(split("/", s.interface), 1
            )}" : coalesce(s.sub_port, false) == false && v.two_slot_leaf == true && length(
            regexall("^\\d{2}$", element(split("/", s.interface), 1))) > 0 ? "Eth${element(split("/", s.interface), 0
              )}-0${element(split("/", s.interface), 1
            )}" : coalesce(s.sub_port, false) == false && v.two_slot_leaf == true && length(
            regexall("^\\d{3}$", element(split("/", s.interface), 1))) > 0 ? "Eth${element(split("/", s.interface), 0
              )}-${element(split("/", s.interface), 1
            )}" : coalesce(s.sub_port, false) == true && v.two_slot_leaf == false && length(
            regexall("^\\d$", element(split("/", s.interface), 1))) > 0 ? "Eth${element(split("/", s.interface), 0
              )}-0${element(split("/", s.interface), 1)}-${element(split("/", s.interface), 2
            )}" : coalesce(s.sub_port, false) == true && v.two_slot_leaf == false && length(
            regexall("^\\d{2}$", element(split("/", s.interface), 1))) > 0 ? "Eth${element(split("/", s.interface), 0
              )}-${element(split("/", s.interface), 1)}-${element(split("/", s.interface), 2
            )}" : coalesce(s.sub_port, false) == false && v.two_slot_leaf == false && length(
            regexall("^\\d$", element(split("/", s.interface), 1))) > 0 ? "Eth${element(split("/", s.interface), 0
              )}-0${element(split("/", s.interface), 1
            )}" : coalesce(s.sub_port, false) == false && v.two_slot_leaf == false && length(
            regexall("^\\d{2}$", element(split("/", s.interface), 1))) > 0 ? "Eth${element(split("/", s.interface), 0
              )}-${element(split("/", s.interface), 1
          )}" : ""
          node_id           = v.node_id
          interface         = s.interface
          module            = element(split("/", s.interface), 0)
          name              = v.name
          node_type         = v.node_type
          port              = element(split("/", s.interface), 1)
          policy_group      = s.policy_group
          policy_group_type = s.policy_group_type
          sub_port          = s.sub_port != false ? element(split("/", s.interface), 2) : ""
        }
      ]
    ]) : "${i.node_id}-Eth${i.interface}" => i
  }

  inband = {
    for i in flatten([
      for k, v in local.switch_profiles : [
        for s in { "default" = v.inband_addressing } : {
          ipv4_address       = lookup(s, "ipv4_address", "")
          ipv4_gateway       = lookup(s, "ipv4_gateway", "")
          ipv6_address       = lookup(s, "ipv6_address", "")
          ipv6_gateway       = lookup(s, "ipv6_gateway", "")
          management_epg = lookup(
            s, "management_epg", local.sprofile.inband_addressing.management_epg
          )
          mgmt_epg_type = "inb"
          name          = v.name
          node_id       = v.node_id
          pod_id        = v.pod_id
        }
      ]
    ]) : "${i.node_id}/${i.mgmt_epg_type}/${i.management_epg}" => i
  }
  ooband = {
    for i in flatten([
      for k, v in local.switch_profiles : [
        for s in { "default" = v.ooband_addressing } : {
          ipv4_address       = lookup(s, "ipv4_address", "")
          ipv4_gateway       = lookup(s, "ipv4_gateway", "")
          ipv6_address       = lookup(s, "ipv6_address", "")
          ipv6_gateway       = lookup(s, "ipv6_gateway", "")
          management_epg = lookup(
            s, "management_epg", local.sprofile.ooband_addressing.management_epg
          )
          mgmt_epg_type = "oob"
          name          = v.name
          node_id       = k
          pod_id        = v.pod_id
        }
      ]
    ]) : "${i.node_id}/${i.mgmt_epg_type}/${i.management_epg}" => i
  }

  static_node_mgmt_addresses = merge(local.inband, local.ooband)

  #__________________________________________________________
  #
  # VPC Domains Variables
  #__________________________________________________________

  vpc_domains = {
    for k, v in lookup(var.switch, "vpc_domains", []) : v.domain_id => {
      domain_id         = v.domain_id
      name              = v.name
      switches          = lookup(v, "switches", local.vpcs.switches)
      vpc_domain_policy = lookup(v, "vpc_domain_policy", local.vpcs.vpc_domain_policy)
    }
  }
}
