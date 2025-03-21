resource "kubernetes_namespace" "cert-manager" {
  count = var.cert-manager == false ? 0 : 1
  metadata {
    name = "cert-manager"
  }
}

resource "helm_release" "cert-manager" {
  count      = var.cert-manager == false ? 0 : 1
  depends_on = [kubernetes_namespace.cert-manager]
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = var.cert_manager_chart_version
  namespace  = "cert-manager"

  values = [jsonencode({
    "crds" : {
      "enabled" : true
    }
  })]
}

resource "kubernetes_secret" "cloudflare-api-token" {
  count      = var.cert-manager == false ? 0 : 1
  depends_on = [kubernetes_namespace.cert-manager]
  metadata {
    name      = "cloudflare-api-token"
    namespace = "cert-manager"
  }

  data = {
    api-token = var.cf_api_token
  }

  type = "Opaque"
}

resource "kubectl_manifest" "cert-manager-cluster-issuer" {
  count      = var.cert-manager == false ? 0 : 1
  depends_on = [kubernetes_secret.cloudflare-api-token, kubernetes_namespace.cert-manager, helm_release.cert-manager]
  yaml_body  = <<-EOF
    apiVersion: cert-manager.io/v1
    kind: ClusterIssuer
    metadata: 
      name: ${var.cert_manager_use_staging_certs == true ? "letsencrypt-staging" : "letsencrypt"}
    spec: 
      acme: 
        server: ${var.cert_manager_use_staging_certs == true ? "https://acme-staging-v02.api.letsencrypt.org/directory" : "https://acme-v02.api.letsencrypt.org/directory"}
        email: ${var.cf_email}
        privateKeySecretRef: 
          name: cluster-issuer-account-key
        solvers: 
        - dns01: 
            cloudflare: 
              email: ${var.cf_email}
              apiTokenSecretRef: 
                name: cloudflare-api-token
                key : api-token
  EOF
}