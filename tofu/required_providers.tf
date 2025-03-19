
terraform {
  required_version = ">= 1.5.0, < 1.6"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 6.23.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5.2"
    }
  }

}