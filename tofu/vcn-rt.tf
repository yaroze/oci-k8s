
# Routing Tables
resource "oci_core_default_route_table" "oke_default_rt" {
  display_name   = "${var.cluster_name}-default-rt"
  compartment_id = oci_identity_compartment.compartment.id
  route_rules {
    description       = "traffic to internet"
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.ig.id
  }
  manage_default_resource_id = oci_core_vcn.oke_vcn.default_route_table_id
}


resource "oci_core_route_table" "routetable_KubernetesAPIendpoint" {
  compartment_id = oci_identity_compartment.compartment.id
  display_name   = "${var.cluster_name}-routetable-KubernetesAPIendpoint"

  route_rules {
    description       = "traffic to the internet"
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.ig.id
  }
  vcn_id = oci_core_vcn.oke_vcn.id
}

resource "oci_core_route_table" "routetable-workernodes" {
  compartment_id = oci_identity_compartment.compartment.id
  display_name   = "${var.cluster_name}-routetable-workernodes"

  route_rules {
    description       = "traffic to the internet"
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.oke_nat_gw.id
  }

  route_rules {
    description = "traffic to OCI services"
    # "all-*-services-in-oracle-services-network"
    destination       = replace(lower([for s in oci_core_service_gateway.oke_service_gateway.services : s.service_name][0]), " ", "-")
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = oci_core_service_gateway.oke_service_gateway.id
  }
  vcn_id = oci_core_vcn.oke_vcn.id
}

resource "oci_core_route_table" "routetable_serviceloadbalancers" {
  compartment_id = oci_identity_compartment.compartment.id
  display_name   = "${var.cluster_name}-routetable-serviceloadbalancers"

  route_rules {
    description       = "traffic to the internet"
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.ig.id
  }
  vcn_id = oci_core_vcn.oke_vcn.id
}