resource "kubernetes_namespace" "external-dns" {
  metadata {
    name = "external-dns"
  }
}

resource "kubernetes_secret" "cloudflare-api-token-edns" {
  depends_on = [kubernetes_namespace.external-dns]
  metadata {
    name      = "cloudflare-api-token"
    namespace = "external-dns"
  }

  data = {
    api-token = var.cf_api_token
  }

  type = "Opaque"
}


resource "helm_release" "external-dns" {
  depends_on       = [kubernetes_secret.cloudflare-api-token-edns]
  name             = "external-dns"
  repository       = "https://kubernetes-sigs.github.io/external-dns"
  chart            = "external-dns"
  version          = var.externaldns_chart_version
  namespace        = "external-dns"
  create_namespace = true

  values = [jsonencode({
    provider = {
      name = "cloudflare"
    },
    env = [
      {
        name = "CF_API_TOKEN"
        valueFrom = {
          secretKeyRef = {
            name = "cloudflare-api-token"
            key  = "api-token"
          }
        }
      }
    ],
    extraArgs = [
      "--exclude-target-net=10.0.0.0/8"
    ]
  })]
}