data "oci_containerengine_cluster_kube_config" "my_cluster_config" {
  cluster_id = oci_containerengine_cluster.my_cluster.id

}


resource "local_file" "foo" {
  content  = <<-EOL
    ${data.oci_containerengine_cluster_kube_config.my_cluster_config.content}
    EOL
  filename = "${path.module}/kubeconfig"
}
