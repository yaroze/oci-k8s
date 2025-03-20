
# Tailscale service
resource "kubernetes_ingress_v1" "stackgres_ingress_tailscale" {

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
      hosts = ["stackgres"]
    }
  }
}