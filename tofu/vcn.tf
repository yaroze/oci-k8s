resource "oci_core_vcn" "oke_vcn" {
  cidr_block     = var.vcn_cidr_block
  compartment_id = var.compartment_ocid
  display_name   = "${var.cluster_name}-vcn"
  dns_label      = var.cluster_name
}