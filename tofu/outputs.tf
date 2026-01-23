output "nodesAvailabilityDomain" {
  value = var.node_availability_domain
}
output "k8sCompartmentID" {
  value = var.compartment_ocid
}
output "kubernetes_cluster_ocid" {
  value = oci_containerengine_cluster.my_cluster.id
}