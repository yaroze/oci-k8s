resource "oci_containerengine_cluster" "my_cluster" {
  cluster_pod_network_options {
    cni_type = var.cni_type
  }
  compartment_id = oci_identity_compartment.compartment.id
  endpoint_config {
    is_public_ip_enabled = "true"
    subnet_id            = oci_core_subnet.api_endpoint_subnet.id
  }
  kubernetes_version = var.kubernetes_version
  name               = var.cluster_name
  options {
    add_ons {
      is_kubernetes_dashboard_enabled = true
      is_tiller_enabled               = false
    }
    kubernetes_network_config {

      pods_cidr = var.pod_subnet_cidr_block

    }
    persistent_volume_config {}
    service_lb_config {}
    service_lb_subnet_ids = [oci_core_subnet.service_lb_subnet.id]
  }
  type   = "BASIC_CLUSTER"
  vcn_id = oci_core_vcn.oke_vcn.id
}

resource "oci_containerengine_node_pool" "pool1" {
  cluster_id     = oci_containerengine_cluster.my_cluster.id
  compartment_id = oci_identity_compartment.compartment.id
  name           = "${var.cluster_name}-np"

  initial_node_labels {
    key   = "name"
    value = "${var.cluster_name}-nodepool"
  }
  kubernetes_version = var.kubernetes_version
  node_config_details {

    is_pv_encryption_in_transit_enabled = "false"

    node_pool_pod_network_option_details {
      #cni_type          = "OCI_VCN_IP_NATIVE"
      cni_type = var.cni_type
      # Applicable when cni_type=OCI_VCN_IP_NATIVE
      #max_pods_per_node = "31"
      #pod_subnet_ids    = [oci_core_subnet.worker_subnet.id]
    }

    placement_configs {
      availability_domain = var.node_availability_domain
      fault_domains       = var.node_fault_domains
      subnet_id           = oci_core_subnet.worker_subnet.id
    }
    size = var.node_count
  }

  node_eviction_node_pool_settings {
    # Evict nodes after 1 minute
    eviction_grace_duration              = "PT1M"
    is_force_delete_after_grace_duration = "true"
  }
  node_shape = "VM.Standard.A1.Flex"
  node_shape_config {
    memory_in_gbs = var.node_memory
    ocpus         = var.node_cpu
  }

  node_source_details {
    image_id    = var.node_image_ocid == "" ? element([for source in data.oci_containerengine_node_pool_option.oci_oke_node_pool_option.sources : source.image_id if length(regexall("Oracle-Linux-${var.node_linux_version}.*OKE-${replace(var.kubernetes_version, "v", "")}.*", source.source_name)) > 0], 0) : var.node_image_ocid
    source_type = "IMAGE"
  }
  ssh_public_key = var.ssh_public_key

}

data "oci_containerengine_node_pool_option" "oci_oke_node_pool_option" {
  node_pool_option_id = oci_containerengine_cluster.my_cluster.id
}