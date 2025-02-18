variable "cf_api_token" {
  description = "Cloudflare API token"
  type        = string
}

variable "cf_email" {
  description = "Cloudflare Email"
  type        = string
}

variable "os_namespace" {
  description = "Object Storage namespace - oci os ns get"
  type        = string
}

variable "stackgres_version" {
  description = "Stackgres version"
  type        = string
  default     = "1.15.0"
}

variable "externaldns_chart_version" {
  description = "Stackgres version"
  type        = string
  default     = "1.15.1"
}

variable "cert-manager-chart-version" {
  description = "Cert Manager chart version"
  type        = string
  default     = "1.16.1"
}

variable "tailscale-chart-version" {
  description = "Tailscale chart version"
  type        = string
  default     = "1.80.0"
}

variable "tailscale_client_secret" {
  description = "The client secret for Tailscale OAuth"
  type        = string
}

variable "tailscale_client_id" {
  description = "The client ID for Tailscale OAuth"
  type        = string
}

variable "domain_name" {
  description = "The domain name for the cluster"
  type        = string
}

variable "tenancy_ocid" {
  description = "The tenancy OCID"
  type        = string
}

variable "region" {
  description = "The region"
  type        = string
  default     = "eu-frankfurt-1"
}