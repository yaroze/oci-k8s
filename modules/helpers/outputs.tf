output "node_availability_domain" {
  value = data.oci_containerengine_node_pools.node_pools.node_pools[0].node_config_details[0].placement_configs[0].availability_domain
}

output "kubeconfig" {
  value = data.oci_containerengine_cluster_kube_config.kubeconfig.content
}

output "cluster_name" {
  value = data.oci_containerengine_cluster.cluster.name
}
