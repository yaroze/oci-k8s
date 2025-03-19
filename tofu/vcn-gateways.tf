
# IGW + Nat GW + SGW
resource "oci_core_internet_gateway" "ig" {
  compartment_id = oci_identity_compartment.compartment.id
  display_name   = "${var.cluster_name}-igw"
  enabled        = "true"
  vcn_id         = oci_core_vcn.oke_vcn.id
}

resource "oci_core_nat_gateway" "oke_nat_gw" {
  compartment_id = oci_identity_compartment.compartment.id
  display_name   = "${var.cluster_name}-natgw"
  vcn_id         = oci_core_vcn.oke_vcn.id
}

data "oci_core_services" "all_oci_services" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
  # Get only the first, which is "All services".
  count = 1
}
resource "oci_core_service_gateway" "oke_service_gateway" {
  compartment_id = oci_identity_compartment.compartment.id
  display_name   = "${var.cluster_name}-servicegw"
  services {
    service_id = data.oci_core_services.all_oci_services[0].services[0]["id"]
  }
  vcn_id = oci_core_vcn.oke_vcn.id
}

