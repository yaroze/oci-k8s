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
    availabilityDomain = module.kubeconfig.node_availability_domain
  }
}

data "kubernetes_storage_class" "oci-bv" {
  metadata {
    name = "oci-bv"
  }
}

resource "kubernetes_annotations" "oci-bv" {
  api_version = "v1"
  kind        = "StrorageClass"
  metadata {
    name = "oci-bv"
  }
  annotations = {
    "storageclass.kubernetes.io/is-default-class" = false
  }
}