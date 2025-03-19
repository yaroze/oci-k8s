resource "oci_identity_compartment" "compartment" {
  compartment_id = var.tenancy_ocid
  name           = "${var.cluster_name}-compartment"
  description    = "Compartment for Kubernetes resources"
  enable_delete  = true
}

