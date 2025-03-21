variable "kubernetes_compartment_ocid" {
  description = "The OCID of the compartment where the Kubernetes cluster is located"
  type        = string
}

variable "kubernetes_cluster_ocid" {
  description = "The OCID of the Kubernetes cluster"
  type        = string
}


variable "stackgres_chart_version" {
  description = "The version of the Stackgres Helm chart to install"
  type        = string
  default     = "1.15.2"
}

variable "region" {
  description = "The region where the Kubernetes cluster is located"
  type        = string
}

variable "oci_profile" {
  description = "The OCI profile to use for the OCI provider"
  type        = string
  default     = "DEFAULT"
}

variable "tenancy_ocid" {
  description = "The OCID of the root compartment"
  type        = string
}

data "kubernetes_ingress_v1" "stackgres_ingress_tailscale" {
  depends_on = [kubernetes_ingress_v1.stackgres_ingress_tailscale]

  metadata {
    name      = "stackgres-adminui-tailscale"
    namespace = "stackgres"
  }

}

# TODO: Need to find a way to retrieve the datasources
# only after the stackgres-operator has been installed
# and the stackgres-ui secret has been
# created
# data "kubernetes_secret" "stackgres_ui_secret" {
#   depends_on = [time_sleep.wait_5m]
#   metadata {
#     name      = "stackgres-restapi-admin"
#     namespace = "stackgres"
#   }
# }


# output "stackgres_admin_password" {
#   depends_on = [time_sleep.wait_5m]
#   value      = nonsensitive(data.kubernetes_secret.stackgres_ui_secret.data["clearPassword"])

# }


# output "stackgres_admin_username" {
#   depends_on = [time_sleep.wait_5m]
#   value      = nonsensitive(data.kubernetes_secret.stackgres_ui_secret.data["k8sUsername"])

# }

output "stackgres_admin_ui_url" {
  value = "https://${data.kubernetes_ingress_v1.stackgres_ingress_tailscale.status[0].load_balancer[0].ingress[0].hostname}"
}