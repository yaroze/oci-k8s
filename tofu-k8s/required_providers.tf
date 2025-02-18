terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "3.0.0-pre1"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.19.0"
    }
  }
}

provider "helm" {
  kubernetes = {
    config_path     = "../tofu/kubeconfig"
    upgrade_install = true
  }
}

provider "kubernetes" {
  config_path = "../tofu/kubeconfig"
}

