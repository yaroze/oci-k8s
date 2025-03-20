resource "kubernetes_namespace" "stackgres" {
  metadata {
    name = "stackgres"
  }
}

# resource "helm_release" "stackgres" {
#   depends_on    = [kubernetes_namespace.stackgres, oci_objectstorage_bucket.stackgres_backup, kubernetes_storage_class.oci-fss]
#   name          = "stackgres-operator"
#   repository    = "https://stackgres.io/downloads/stackgres-k8s/stackgres/helm/"
#   chart         = "stackgres-operator"
#   version       = var.stackgres_version
#   namespace     = "stackgres"
#   wait_for_jobs = true
#   timeout       = 600

#   values = [jsonencode({
#     "adminui" : {
#       "service" : {
#         "type" : "ClusterIP"
#       "exposeHTTP" : true }
#     }
#   })]
# }

# resource "oci_objectstorage_bucket" "stackgres_backup" {
#   #Required
#   compartment_id = data.terraform_remote_state.tofu.outputs.k8sCompartmentID
#   name           = "stackgres-backups"
#   namespace      = var.os_namespace
# }
# # ALLOW any-user to manage file-family in compartment Kubernetes where request.principal.type = 'cluster'	
# resource "oci_identity_user" "stackgres" {
#   compartment_id = var.tenancy_ocid
#   description    = "IAM user for Stackgres"
#   name           = "stackgres"

# }
# resource "oci_identity_group" "stackgres" {
#   compartment_id = var.tenancy_ocid
#   description    = "IAM group for Stackgres"
#   name           = "stackgres-backup-group"
# }

# resource "oci_identity_user_group_membership" "stackgres_group_membership" {
#   group_id = oci_identity_group.stackgres.id
#   user_id  = oci_identity_user.stackgres.id
# }

# resource "oci_identity_policy" "backup_policy" {
#   #Required
#   compartment_id = var.tenancy_ocid
#   description    = "Allow Stackgres to backup databases to the Bucket"
#   name           = "stackgres_backups"
#   statements = [
#     "ALLOW group ${oci_identity_group.stackgres.name} to use bucket on compartment id ${data.terraform_remote_state.tofu.outputs.k8sCompartmentID} where target.bucket.name = '${oci_objectstorage_bucket.stackgres_backup.name}'"
#   ]
# }

# resource "oci_identity_customer_secret_key" "stackgres_backups" {
#   display_name = "stackgres_backups"
#   user_id      = oci_identity_user.stackgres.id
# }

# resource "kubernetes_secret" "stackgres_backups" {
#   metadata {
#     name      = "stackgres-backups-secret"
#     namespace = helm_release.stackgres.namespace
#   }
#   data = {
#     accessKeyId     = oci_identity_customer_secret_key.stackgres_backups.id
#     secretAccessKey = oci_identity_customer_secret_key.stackgres_backups.key
#   }
# }


# resource "kubectl_manifest" "sg_backup_object" {
#   yaml_body = <<-EOF
#     apiVersion: stackgres.io/v1beta1
#     kind: SGObjectStorage
#     metadata:
#       name: stackgres-backups
#       namespace: ${helm_release.stackgres.namespace}
#     spec:
#       s3Compatible:
#         awsCredentials:
#           secretKeySelectors:
#             accessKeyId:
#               key: accessKeyId
#               name: ${kubernetes_secret.stackgres_backups.metadata.0.name}
#             secretAccessKey:
#               key: secretAccessKey
#               name: ${kubernetes_secret.stackgres_backups.metadata.0.name}
#         bucket: ${oci_objectstorage_bucket.stackgres_backup.name}
#         endpoint: https://${var.os_namespace}.compat.objectstorage.${var.region}.oraclecloud.com
#         region: ${var.region}
#       type: s3Compatible
# EOF
# }

# # resource "kubernetes_ingress_v1" "stackgres_ingress" {
# #   metadata {
# #     name      = "stackgres-ui"
# #     namespace = helm_release.stackgres.namespace
# #     annotations = {
# #       "cert-manager.io/cluster-issuer" = "letsencrypt"
# #     }
# #   }
# #   spec {
# #     ingress_class_name = "traefik"
# #     rule {
# #       host = "stackgres.${var.domain_name}"
# #       http {
# #         path {
# #           path = "/"
# #           backend {
# #             service {
# #               name = "stackgres-restapi"
# #               port {
# #                 number = 80
# #               }
# #             }
# #           }
# #         }
# #       }
# #     }
# #   }
# # }

# # Tailscale service
# resource "kubernetes_ingress_v1" "stackgres_ingress_tailscale" {
#   metadata {
#     name      = "stackgres-adminui-tailscale"
#     namespace = helm_release.stackgres.namespace
#   }
#   spec {
#     ingress_class_name = "tailscale"
#     default_backend {
#       service {
#         name = "stackgres-restapi"
#         port {
#           number = 80
#         }
#       }
#     }
#     tls {
#       hosts = ["stackgres"]
#     }

#   }
# }