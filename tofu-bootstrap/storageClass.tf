resource "kubernetes_storage_class" "oci-fss" {
  count = var.oci-fss-storageclass == false ? 0 : 1

  allow_volume_expansion = true
  reclaim_policy         = "Delete"
  volume_binding_mode    = "WaitForFirstConsumer"
  metadata {
    annotations = { "storageclass.kubernetes.io/is-default-class" : true }
    name        = "oci-fss"
  }
  storage_provisioner = "fss.csi.oraclecloud.com"
  parameters = {

    mountTargetOcid    = oci_file_storage_mount_target.filesystem_mount_target[0].id
    exportOptions      = "[{\"source\":\"${var.workerCIDR}\",\"requirePrivilegedSourcePort\":false,\"access\":\"READ_WRITE\",\"identitySquash\":\"NONE\"}]"
    encryptInTransit   = "false"
    availabilityDomain = module.helpers.node_availability_domain
  }
}

data "kubernetes_storage_class" "oci-bv" {
  metadata {
    name = "oci-bv"
  }
}

# Disable the default storage class
resource "kubernetes_annotations" "oci-bv" {
  api_version = "storage.k8s.io/v1"
  kind        = "StorageClass"

  # This is necessary because TF thinks there is something else managing this resource:
  /*
      Error: Field manager conflict

      with kubernetes_annotations.oci-bv,
      on storageClass.tf line 28, in resource "kubernetes_annotations" "oci-bv":
      28: resource "kubernetes_annotations" "oci-bv" {

      Another client is managing a field Terraform tried to update. Set "force" to true to override:
      Apply failed with 1 conflict: conflict with "Kubernetes Java Client" using storage.k8s.io/v1:
      .metadata.annotations.storageclass.kubernetes.io/is-default-class
  */
  force       = true

  metadata {
    name = "oci-bv"
  }
  annotations = {
    "storageclass.kubernetes.io/is-default-class" = false
  }
}