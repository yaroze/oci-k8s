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

# unset the block volume storage class as default
resource "kubernetes_storage_class" "oci-bv" {
  count = var.oci-fss-storageclass == false ? 0 : 1

  allow_volume_expansion = true
  reclaim_policy         = "Delete"
  volume_binding_mode    = "WaitForFirstConsumer"
  metadata {
    annotations = { "storageclass.kubernetes.io/is-default-class" : false }
    name        = "oci-bv"
  }
  storage_provisioner = "blockvolume.csi.oraclecloud.com"
}

# This is necessary so that the File System's root is created with the same UID as the pods
resource "kubectl_manifest" "fss_csi_driver" {
  count = var.oci-fss-storageclass == false ? 0 : 1

  yaml_body = <<-EOF
    apiVersion: storage.k8s.io/v1
    kind: CSIDriver
    metadata:
      name: fss.csi.oraclecloud.com
    spec:
      attachRequired: false
      fsGroupPolicy: File
      podInfoOnMount: false
      requiresRepublish: false
      seLinuxMount: false
      storageCapacity: false
      volumeLifecycleModes:
      - Persistent
EOF
}
