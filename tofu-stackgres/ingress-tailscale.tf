
# Tailscale service
resource "kubernetes_ingress_v1" "stackgres_ingress_tailscale" {

  count = var.create_tailscale_url == true ? 1 : 0


  metadata {
    name      = "stackgres-adminui-tailscale"
    namespace = helm_release.stackgres.namespace
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
      hosts = [var.tailscale_subdomain]
    }
  }
}