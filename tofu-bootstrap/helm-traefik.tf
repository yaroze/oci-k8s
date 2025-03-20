resource "kubernetes_namespace" "traefik" {
  count = var.traefik == false ? 0 : 1

  metadata {
    name = "traefik"
  }
}

# Creating a single NLB for Traefik
# https://docs.oracle.com/en-us/iaas/Content/NetworkLoadBalancer/overview.htm
resource "helm_release" "traefik" {
  count = var.traefik == false ? 0 : 1

  depends_on = [kubernetes_namespace.traefik]
  name       = "traefik"
  repository = "https://helm.traefik.io/traefik"
  chart      = "traefik"
  version    = "34.3.0"
  namespace  = "traefik"

  values = [jsonencode(
    {
      "ingressRoute" : {
        "dashboard" : {
          "enabled" : true
        }
      },
      "service" : {
        "spec" : {
          "externalTrafficPolicy" : "Cluster"
        },
        "annotations" : {
          "oci.oraclecloud.com/load-balancer-type" : "nlb",
          "service.beta.kubernetes.io/oci-load-balancer-shape" : "flexible",
          #"service.beta.kubernetes.io/oci-load-balancer-shape-flex-min" : "10",
          #"service.beta.kubernetes.io/oci-load-balancer-shape-flex-max" : "100",
          "external-dns.alpha.kubernetes.io/ttl" : "120",
          "external-dns.alpha.kubernetes.io/access" : "public"
        }
      }
  })]
}

