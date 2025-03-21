terraform {
  required_version = ">= 1.5.0, < 1.6"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "3.0.0-pre1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.19.0"
    }
    oci = {
      source  = "oracle/oci"
      version = "~> 6.23.0"
    }
    # Needed to allow the creation of secrets
    time = {
      source  = "hashicorp/time"
      version = "0.13.0"
    }
  }
}


provider "kubernetes" {
  host                   = yamldecode(module.helpers.kubeconfig).clusters[0].cluster.server
  cluster_ca_certificate = base64decode(yamldecode(module.helpers.kubeconfig).clusters[0].cluster.certificate-authority-data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["ce", "cluster", "generate-token", "--cluster-id", var.kubernetes_cluster_ocid, "--region", var.region, "--profile", var.oci_profile]
    command     = "oci"
  }
}

provider "helm" {
  kubernetes = {
    host                   = yamldecode(module.helpers.kubeconfig).clusters[0].cluster.server
    cluster_ca_certificate = base64decode(yamldecode(module.helpers.kubeconfig).clusters[0].cluster.certificate-authority-data)

    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["ce", "cluster", "generate-token", "--cluster-id", var.kubernetes_cluster_ocid, "--region", var.region, "--profile", var.oci_profile]
      command     = "oci"
    }
  }
}


module "helpers" {
  source                      = "https://github.com/yaroze/oci-k8s/releases/latest/download/helpers.zip"
  kubernetes_compartment_ocid = var.kubernetes_compartment_ocid
  kubernetes_cluster_ocid     = var.kubernetes_cluster_ocid
}


provider "kubectl" {
  host                   = yamldecode(module.helpers.kubeconfig).clusters[0].cluster.server
  cluster_ca_certificate = base64decode(yamldecode(module.helpers.kubeconfig).clusters[0].cluster.certificate-authority-data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["ce", "cluster", "generate-token", "--cluster-id", var.kubernetes_cluster_ocid, "--region", var.region, "--profile", var.oci_profile]
    command     = "oci"
  }
}