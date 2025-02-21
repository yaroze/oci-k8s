resource "oci_identity_policy" "kubernetes_policy" {

  compartment_id = var.tenancy_ocid
  description    = "Policy for Kubernetes clusters"
  name           = "KubernetesPolicy"
  statements = ["ALLOW any-user to manage file-family in compartment ${var.new_compartment_name} where request.principal.type = 'cluster'",
    "ALLOW any-user to manage load-balancers in compartment ${var.new_compartment_name} where request.principal.type = 'cluster'",
    "ALLOW any-user to manage vn-path-analyzer-test in compartment ${var.new_compartment_name} where request.principal.type = 'cluster'",
  "ALLOW any-user to use virtual-network-family in compartment ${var.new_compartment_name} where request.principal.type = 'cluster'"]
}