resource "kubernetes_namespace" "tailscale" {
  metadata {
    name = "tailscale"
  }
}

resource "helm_release" "tailscale" {
  depends_on = [kubernetes_namespace.tailscale]
  name       = "tailscale"
  repository = "https://pkgs.tailscale.com/helmcharts"
  chart      = "tailscale-operator"
  version    = var.tailscale-chart-version
  namespace  = "tailscale"

  values = [jsonencode({
    "oauth" : {
      "clientId" : "${var.tailscale_client_id}"
      "clientSecret" : "${var.tailscale_client_secret}"
    }
  })]
}

