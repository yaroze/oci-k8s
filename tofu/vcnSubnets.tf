
# Subnets
# Public subnet
resource "oci_core_subnet" "service_lb_subnet" {
  cidr_block                 = var.service_subnet_cidr_block
  compartment_id             = oci_identity_compartment.compartment.id
  display_name               = "${var.cluster_name}-svc-lb-subnet"
  dns_label                  = "svclbsubnet"
  prohibit_public_ip_on_vnic = "false"
  route_table_id             = oci_core_route_table.routetable_serviceloadbalancers.id
  security_list_ids          = [oci_core_security_list.service_lb_sec_list.id]
  vcn_id                     = oci_core_vcn.oke_vcn.id
}

resource "oci_core_subnet" "worker_subnet" {
  cidr_block                 = var.worker_subnet_cidr_block
  compartment_id             = oci_identity_compartment.compartment.id
  display_name               = "${var.cluster_name}-worker-subnet"
  dns_label                  = "nodesubnet"
  prohibit_public_ip_on_vnic = "true"
  #route_table_id             = oci_core_route_table.oke_routetable.id
  route_table_id    = oci_core_route_table.routetable-workernodes.id
  security_list_ids = [oci_core_security_list.worker_sec_list.id]
  vcn_id            = oci_core_vcn.oke_vcn.id
}

resource "oci_core_subnet" "api_endpoint_subnet" {
  cidr_block                 = var.api_subnet_cidr_block
  compartment_id             = oci_identity_compartment.compartment.id
  display_name               = "${var.cluster_name}-api-endpoint-subnet"
  dns_label                  = "apisubnet"
  prohibit_public_ip_on_vnic = "false"
  route_table_id             = oci_core_route_table.routetable_KubernetesAPIendpoint.id
  security_list_ids          = [oci_core_security_list.api_endpoint_sec_list.id]
  vcn_id                     = oci_core_vcn.oke_vcn.id
}
