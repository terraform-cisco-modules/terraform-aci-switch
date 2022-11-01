locals {
  defaults = lookup(var.model, "defaults", {})
  switch   = lookup(var.model, "switch", {})
  sprofile = local.defaults.switch.switch_profiles
  vpcs     = local.defaults.switch.vpc_domains

  #__________________________________________________________
  #
  # Leaf Profiles Variables
  #__________________________________________________________

  switch_profiles = {
    for k, v in lookup(local.switch, "switch_profiles", []) : v.name => {
      annotation = coalesce(lookup(v, "annotation", local.sprofile.annotation
      ), var.annotation)
      description       = lookup(v, "description", local.sprofile.description)
      external_pool_id  = lookup(v, "external_pool_id", local.sprofile.external_pool_id)
      inband_addressing = lookup(v, "inband_addressing", [])
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
      policy_group      = lookup(v, "policy_group", local.sprofile.policy_group)
      monitoring_policy = lookup(v, "monitoring_policy", local.sprofile.monitoring_policy)
      name              = v.name
      node_id           = v.node_id
      node_type         = lookup(v, "node_type", local.sprofile.node_type)
      ooband_addressing = lookup(v, "ooband_addressing", [])
      pod_id            = lookup(v, "pod_id", local.sprofile.pod_id)
      role              = lookup(v, "role", local.sprofile.role)
      serial_number     = v.serial_number
      two_slot_leaf     = lookup(v, "two_slot_leaf", local.sprofile.two_slot_leaf)
    }
  }

  interface_selectors = {
    for i in flatten([
      for k, v in local.switch_profiles : [
        for s in v.interfaces : {
          annotation            = v.annotation
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
          node_id           = k
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
          annotation         = v.annotation
          ipv4_address       = lookup(s, "ipv4_address", "")
          ipv4_gateway       = lookup(s, "ipv4_gateway", "")
          ipv6_address       = lookup(s, "ipv6_address", "")
          ipv6_gateway       = lookup(s, "ipv6_gateway", "")
          management_epg = lookup(
            s, "management_epg", local.sprofile.inband_addressing.management_epg
          )
          mgmt_epg_type = "inb"
          node_id       = k
          pod_id        = v.pod_id
        }
      ]
    ]) : "${i.node_id}:${i.mgmt_epg_type}:${i.management_epg}" => i
  }
  ooband = {
    for i in flatten([
      for k, v in local.switch_profiles : [
        for s in { "default" = v.ooband_addressing } : {
          annotation         = v.annotation
          ipv4_address       = lookup(s, "ipv4_address", "")
          ipv4_gateway       = lookup(s, "ipv4_gateway", "")
          ipv6_address       = lookup(s, "ipv6_address", "")
          ipv6_gateway       = lookup(s, "ipv6_gateway", "")
          management_epg = lookup(
            s, "management_epg", local.sprofile.ooband_addressing.management_epg
          )
          mgmt_epg_type = "oob"
          node_id       = k
          pod_id        = v.pod_id
        }
      ]
    ]) : "${i.node_id}:${i.mgmt_epg_type}:${i.management_epg}" => i
  }

  static_node_mgmt_addresses = merge(local.inband, local.ooband)

  #__________________________________________________________
  #
  # VPC Domains Variables
  #__________________________________________________________

  vpc_domains = {
    for k, v in lookup(local.switch, "vpc_domains", []) : k => {
      annotation = coalesce(lookup(v, "annotation", local.vpcs.annotation
      ), var.annotation)
      domain_id         = v.domain_id
      name              = v.name
      switches          = lookup(v, "switches", local.vpcs.switches)
      vpc_domain_policy = lookup(v, "vpc_domain_policy", local.vpcs.vpc_domain_policy)
    }
  }
}
