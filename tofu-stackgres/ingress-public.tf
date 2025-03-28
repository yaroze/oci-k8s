
# Public service
resource "kubernetes_ingress_v1" "stackgres_ingress" {

  count = var.create_public_url == true ? 1 : 0

  metadata {
    name        = "stackgres-ui"
    namespace   = helm_release.stackgres.namespace
    annotations = var.stackgres_use_tls_for_public_url ? { "cert-manager.io/cluster-issuer" = "${var.cert_manager_use_staging_certs == true ? "letsencrypt-staging" : "letsencrypt"}" } : {}
  }

  spec {
    ingress_class_name = "traefik"
    rule {
      host = var.public_url
      http {
        path {
          path = "/"
          backend {
            service {
              name = "stackgres-restapi"
              port {
                number = 80
              }
            }
          }
        }
      }
    }

    dynamic "tls" {
      for_each = var.stackgres_use_tls_for_public_url ? [1] : []
      content {
        hosts       = [var.public_url]
        secret_name = "${replace(var.public_url, ".", "-")}-tls"

      }
    }
  }
}

