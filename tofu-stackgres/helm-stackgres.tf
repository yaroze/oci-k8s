resource "kubernetes_namespace" "stackgres" {
  metadata {
    name = "stackgres"
  }
}

resource "helm_release" "stackgres" {
  depends_on    = [kubernetes_namespace.stackgres]
  name          = "stackgres-operator"
  repository    = "https://stackgres.io/downloads/stackgres-k8s/stackgres/helm/"
  chart         = "stackgres-operator"
  version       = var.stackgres_chart_version
  namespace     = kubernetes_namespace.stackgres.metadata.0.name
  wait_for_jobs = true
  timeout       = 600

  values = [jsonencode({
    "adminui" : {
      "service" : {
        "type" : "ClusterIP"
      "exposeHTTP" : true }
    }
  })]
}



# # # resource "kubernetes_ingress_v1" "stackgres_ingress" {
# # #   metadata {
# # #     name      = "stackgres-ui"
# # #     namespace = helm_release.stackgres.namespace
# # #     annotations = {
# # #       "cert-manager.io/cluster-issuer" = "letsencrypt"
# # #     }
# # #   }
# # #   spec {
# # #     ingress_class_name = "traefik"
# # #     rule {
# # #       host = "stackgres.${var.domain_name}"
# # #       http {
# # #         path {
# # #           path = "/"
# # #           backend {
# # #             service {
# # #               name = "stackgres-restapi"
# # #               port {
# # #                 number = 80
# # #               }
# # #             }
# # #           }
# # #         }
# # #       }
# # #     }
# # #   }
# # # }
