
resource "oci_file_storage_file_system" "fs" {
  count = var.oci-fss-storageclass == false ? 0 : 1

  availability_domain = module.helpers.node_availability_domain
  compartment_id      = var.kubernetes_compartment_ocid
  display_name        = "${module.helpers.cluster_name}-fs"
}

resource "oci_file_storage_mount_target" "filesystem_mount_target" {
  count = var.oci-fss-storageclass == false ? 0 : 1

  availability_domain = module.helpers.node_availability_domain
  compartment_id      = var.kubernetes_compartment_ocid
  display_name        = "${module.helpers.cluster_name}-mt"
  subnet_id           = var.oci-fss-subnet-id == "" ? data.oci_core_subnets.worker_subnet_default.subnets[0].id : var.oci-fss-subnet-id
}

resource "oci_file_storage_export" "generated_oci_file_storage_export" {
  count = var.oci-fss-storageclass == false ? 0 : 1

  export_set_id  = oci_file_storage_mount_target.filesystem_mount_target[0].export_set_id
  file_system_id = oci_file_storage_file_system.fs[0].id
  path           = "/${module.helpers.cluster_name}-fs"
  export_options {
    source                      = data.oci_core_subnet.fss-subnet.cidr_block
    is_anonymous_access_allowed = true
  }
}


data "oci_core_subnets" "worker_subnet_default" {
  display_name   = "${module.helpers.cluster_name}-worker-subnet"
  compartment_id = var.kubernetes_compartment_ocid
}

data "oci_core_subnet" "fss-subnet" {
  subnet_id = var.oci-fss-subnet-id == "" ? data.oci_core_subnets.worker_subnet_default.subnets[0].id : var.oci-fss-subnet-id
}

data "oci_core_subnet" "worker_subnet" {
  subnet_id = var.oci-fss-subnet-id == "" ? "not-selected" : var.oci-fss-subnet-id
}