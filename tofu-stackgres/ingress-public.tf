
# Public service

locals {
  annotations     = var.stackgres_use_tls_for_public_url ? { "cert-manager.io/cluster-issuer" = "${var.cert_manager_use_staging_certs == true ? "letsencrypt-staging" : "letsencrypt"}" } : {}
  add_annotations = local.annotations
}


resource "kubernetes_ingress_v1" "stackgres_ingress_public" {
  count = var.create_public_url == true ? 1 : 0
  metadata {
    name      = "stackgres"
    namespace = helm_release.stackgres.namespace

    annotations = local.add_annotations
  }
  spec {
    ingress_class_name = "tailscale"
    default_backend {
      service {
        name = "stackgres-restapi"
        port {
          number = 80
        }
      }
    }
    tls {
      hosts = ["stackgres"]
    }
  }
}