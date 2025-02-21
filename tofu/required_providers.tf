
terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 6.23.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.35.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5.2"
    }
  }

}

provider "oci" {
  tenancy_ocid     = "ocid1.tenancy.oc1..aaaaaaaahxdsci6hnhxkauimwus4le5uo72426xf24xmmwjvxkrunci3nugq"
  user_ocid        = "ocid1.user.oc1..aaaaaaaaqobec6k25yxhzsp3ld3xv4wlx4eol64tns5w7emxikr2tybjol4q"
  private_key_path = "/Users/pedro/.oci/sessions/madrid/oci_api_key.pem"
  fingerprint      = "df:0c:47:a8:39:25:66:f2:1a:5f:91:b3:75:cf:8f:c0"
  region           = "eu-madrid-1"
}