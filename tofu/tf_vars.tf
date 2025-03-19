variable "tenancy_ocid" {
  # This is required
  description = "The OCID of the root compartment"
  type        = string
}

variable "node_fault_domains" {
  description = "Fault domains"
  type        = list(string)
  default     = ["FAULT-DOMAIN-1", "FAULT-DOMAIN-2", "FAULT-DOMAIN-3"]
}

# oci iam availability-domain list
variable "node_availability_domain" {
  description = "Node Availability Domain"
  type        = string
  default     = ""
}


variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "v1.31.1"
}

variable "node_image_ocid" {
  description = "The OCID of the image"
  type        = string
  # Oracle-Linux-8.10-aarch64-2024.09.30-0-OKE-1.31.1-747
  default = ""
}
variable "cluster_name" {
  description = "Cluster name"
  type        = string
  default     = "k8s01"
}
variable "ssh_public_key" {
  description = "The contents of the public key. This key will be placed on all nodes"
  type        = string
  default     = ""
}

variable "cni_type" {
  description = "CNI type"
  type        = string
  default     = "FLANNEL_OVERLAY"
}

variable "vcn_cidr_block" {
  description = "CIDR block for the VCN"
  type        = string
  default     = "10.0.0.0/16"
}

variable "worker_subnet_cidr_block" {
  description = "Private Subnet for Worker Nodes"
  type        = string
  default     = "10.0.1.0/24"
}


variable "api_subnet_cidr_block" {
  description = "Public Subnet for Kubernetes API Endpoint"
  type        = string
  default     = "10.0.0.0/30"
}

variable "pod_subnet_cidr_block" {
  description = "CIDR block for the pod subnet"
  type        = string
  default     = "10.244.0.0/16"
}

variable "service_subnet_cidr_block" {
  description = "Public Subnet for Service Load Balancers"
  type        = string
  default     = "10.0.2.0/24"
}


variable "new_compartment_name" {
  description = "Name of the new compartment"
  type        = string
  default     = "k8s01-compartment"
}

variable "node_linux_version" {
  description = "Node Linux version"
  type        = string
  default     = "8"
}

variable "node_cpu" {
  description = "Node CPU"
  type        = string
  default     = "2"
}

variable "node_memory" {
  description = "Node Memory"
  type        = string
  default     = "8"
}

variable "node_count" {
  description = "Node count"
  type        = number
  default     = 2
}

variable "node_shape" {
  description = "Node shape"
  type        = string
  default     = "VM.Standard.A1.Flex"
}

