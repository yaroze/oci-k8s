resource "kubernetes_namespace" "tailscale" {
  count = var.tailscale == false ? 0 : 1

  metadata {
    name = "tailscale"
  }
}

resource "helm_release" "tailscale" {
  count = var.tailscale == false ? 0 : 1

  depends_on = [kubernetes_namespace.tailscale]
  name       = "tailscale"
  repository = "https://pkgs.tailscale.com/helmcharts"
  chart      = "tailscale-operator"
  version    = var.tailscale_chart_version
  namespace  = "tailscale"

  values = [jsonencode({
    "oauth" : {
      "clientId" : "${var.tailscale_client_id}"
      "clientSecret" : "${var.tailscale_client_secret}"
    }
  })]
}

