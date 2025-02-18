
resource "oci_file_storage_file_system" "fs" {
  availability_domain = var.node_availability_domain
  compartment_id      = oci_identity_compartment.compartment.id
  display_name        = "k8s-fs"
}

resource "oci_file_storage_mount_target" "filesystem_mount_target" {
  availability_domain = var.node_availability_domain
  compartment_id      = oci_identity_compartment.compartment.id
  display_name        = "${var.cluster_name}-mounttarget"
  subnet_id           = oci_core_subnet.worker_subnet.id
}

resource "oci_file_storage_export" "generated_oci_file_storage_export" {
  export_set_id  = oci_file_storage_mount_target.filesystem_mount_target.export_set_id
  file_system_id = oci_file_storage_file_system.fs.id
  path           = "/${var.cluster_name}-fs"
  export_options {
    source                      = var.vcn_cidr_block
    is_anonymous_access_allowed = true
  }
}

