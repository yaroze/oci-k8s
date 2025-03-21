data "oci_objectstorage_namespace" "namespace" {

  #Optional
  compartment_id = var.tenancy_ocid
}

resource "oci_objectstorage_bucket" "stackgres_backup" {
  compartment_id = var.kubernetes_compartment_ocid
  name           = "stackgres-backups"
  namespace      = data.oci_objectstorage_namespace.namespace.namespace
}