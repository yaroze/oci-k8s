output "nodesAvailabilityDomain" {
  value = var.node_availability_domain
}

output "workerCIDR" {
  value = var.worker_subnet_cidr_block
}

output "k8sCompartmentID" {
  value = oci_identity_compartment.compartment.id
}

data "oci_containerengine_cluster_option" "node_pool_option" {
  cluster_option_id = "all"

}

data "oci_containerengine_cluster_kube_config" "cluster_kube_config" {
  cluster_id = oci_containerengine_cluster.my_cluster.id
}


output "kubeconfig" {
  value = data.oci_containerengine_cluster_kube_config.cluster_kube_config.content
}