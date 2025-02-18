resource "kubernetes_storage_class" "oci-fss" {
  allow_volume_expansion = true
  reclaim_policy         = "Delete"
  volume_binding_mode    = "WaitForFirstConsumer"
  metadata {
    annotations = { "storageclass.kubernetes.io/is-default-class" : true }
    name        = "oci-fss"
  }
  storage_provisioner = "fss.csi.oraclecloud.com"
  parameters = {

    mountTargetOcid    = data.terraform_remote_state.tofu.outputs.mountTargetOCID
    exportOptions      = "[{\"source\":\"${data.terraform_remote_state.tofu.outputs.workerCIDR}\",\"requirePrivilegedSourcePort\":false,\"access\":\"READ_WRITE\",\"identitySquash\":\"NONE\"}]"
    encryptInTransit   = "false"
    availabilityDomain = data.terraform_remote_state.tofu.outputs.nodesAvailabilityDomain
  }
}

# This is necessary so that the File System's root is created with the same UID as the pods
resource "kubectl_manifest" "fss_csi_driver" {
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