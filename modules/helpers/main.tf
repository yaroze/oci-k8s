# Get selected Kubernetes cluster
data "oci_containerengine_cluster" "cluster" {
  cluster_id = var.kubernetes_cluster_ocid
}

# Get node pool
data "oci_containerengine_node_pools" "node_pools" {
    compartment_id = var.kubernetes_compartment_ocid

    cluster_id = var.kubernetes_cluster_ocid
    name = "${data.oci_containerengine_cluster.cluster.name}-np"
}


# Get Kubeconfig
data "oci_containerengine_cluster_kube_config" "kubeconfig" {
    cluster_id = var.kubernetes_cluster_ocid
}





