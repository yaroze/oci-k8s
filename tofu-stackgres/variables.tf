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