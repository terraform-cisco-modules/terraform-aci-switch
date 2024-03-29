/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "fabricProtPol"
 - Distinguished Name: "uni/fabric/protpol"
GUI Location:
 - Fabric > Access Policies > Policies > Virtual Port Channel default
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "virtual_port_channel_default" {
  for_each   = { for v in ["default"] : v => v if length(local.vpc_domains) > 0 }
  class_name = "fabricProtPol"
  dn         = "uni/fabric/protpol"
  content = {
    #annotation = "orchestrator:terraform"
    descr = "Managed by Terraform"
  }
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "fabricExplicitGEp"
 - Distinguished Name: "uni/fabric/protpol/expgep-{name}"
GUI Location:
 - Fabric > Access Policies > Policies > Virtual Port Channel default
_______________________________________________________________________________________________________________________
*/
resource "aci_vpc_explicit_protection_group" "vpc_domains" {
  depends_on = [
    aci_rest_managed.fabric_membership,
  ]
  for_each                         = { for k, v in local.vpc_domains : v.domain_id => v if length(v.switches) == 2 }
  name                             = each.value.name
  switch1                          = element(each.value.switches, 0)
  switch2                          = element(each.value.switches, 1)
  vpc_domain_policy                = each.value.vpc_domain_policy
  vpc_explicit_protection_group_id = each.key
}
