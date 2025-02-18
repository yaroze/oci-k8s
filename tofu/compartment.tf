resource "oci_identity_compartment" "compartment" {
  compartment_id = var.tenancy_ocid
  name           = var.new_compartment_name
  description    = "Compartment for Kubernetes resources"
  enable_delete  = true
}

