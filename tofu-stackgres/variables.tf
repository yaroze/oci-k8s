variable "stackgres_version" {
  description = "Version of the Stackgres Helm chart to deploy."
  type        = string
  default     = "1.3.0"
}

variable "os_namespace" {
  description = "Object Storage namespace for the OCI bucket."
  type        = string
}

variable "tenancy_ocid" {
  description = "OCID of the tenancy where resources will be created."
  type        = string
}

variable "region" {
  description = "OCI region where the resources will be deployed."
  type        = string
}

variable "domain_name" {
  description = "Domain name for the Stackgres ingress."
  type        = string
}
