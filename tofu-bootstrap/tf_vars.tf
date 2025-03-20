variable "tenancy_ocid" {
  description = "The OCID of the root compartment"
  type        = string
}

variable "kubernetes_cluster_ocid" {
  description = "The OCID of the Kubernetes cluster"
  type        = string
}

variable "kubernetes_compartment_ocid" {
  description = "Name of the new compartment"
  type        = string
}

variable "oci_profile" {
  description = "OCI Profile"
  type        = string
  default     = "DEFAULT"
}

variable "workerCIDR" {
  description = "Worker CIDR"
  type        = string
  default     = "10.0.1.0/24"
}

variable "tailscale_client_id" {
  description = "Tailscale client ID"
  type        = string
  default     = ""
}

variable "tailscale_client_secret" {
  description = "Tailscale client secret"
  type        = string
  default     = ""
}

variable "tailscale_chart_version" {
  description = "Tailscale chart version"
  type        = string
  default     = "1.80.3"
}

variable "cf_api_token" {
  description = "Cloudflare API Token"
  type        = string
  default     = ""
}

variable "cf_email" {
  description = "Cloudflare Email"
  type        = string
  default     = ""
}

variable "externaldns_chart_version" {
  description = "External DNS chart version"
  type        = string
  default     = "1.15.2"
}
variable "cert_manager_chart_version" {
  description = "Cert Manager chart version"
  type        = string
  default     = "v1.17.1"
}

variable "external-dns" {
  description = "Enable External DNS"
  type        = bool
  default     = true
}

variable "traefik" {
  description = "Enable Traefik"
  type        = bool
  default     = true
}

variable "cert-manager" {
  description = "Enable Cert-Manager"
  type        = bool
  default     = true
}

variable "tailscale" {
  description = "Enable Tailscale"
  type        = bool
  default     = true
}

variable "cert_manager_staging_or_production" {
  description = "Use staging certificates for cert-manager?"
  type        = bool
  default     = true
}

variable "oci-fss-storageclass" {
  description = "Enable OCI FSS StorageClass"
  type        = bool
  default     = true
}


variable "oci-fss-subnet-id" {
  description = "OCI FSS subnet ID"
  type        = string
  default     = ""
}

variable "region" {
  description = "OCI region"
  type        = string
}