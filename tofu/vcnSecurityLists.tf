
# Security Lists
# https://docs.oracle.com/en-us/iaas/Content/ContEng/Concepts/contengnetworkconfigexample.htm#example-oci-cni-publick8sapi_privateworkers_publiclb
resource "oci_core_security_list" "service_lb_sec_list" {
  compartment_id = oci_identity_compartment.compartment.id
  display_name   = "oke-svclbseclist-${var.cluster_name}"
  vcn_id         = oci_core_vcn.oke_vcn.id


  ingress_security_rules {
    description = "HTTP Traffic"
    protocol    = "6"
    source      = "0.0.0.0/0"
    stateless   = "false"
    tcp_options {
      min = 80
      max = 80
    }
  }
  ingress_security_rules {
    description = "HTTPS Traffic"
    protocol    = "6"
    source      = "0.0.0.0/0"
    stateless   = "false"
    tcp_options {
      min = 443
      max = 443
    }
  }


  egress_security_rules {
    description      = "Load balancer to worker nodes node ports (all TCP ports)."
    destination      = var.worker_subnet_cidr_block
    destination_type = "CIDR_BLOCK"
    protocol         = "6"
    stateless        = "false"
  }

  egress_security_rules {
    description      = "Allow the load balancers to egress with the Internet."
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "6"
    stateless        = "false"
  }

}

resource "oci_core_security_list" "worker_sec_list" {
  compartment_id = oci_identity_compartment.compartment.id
  display_name   = "oke-workerseclist"

  ingress_security_rules {
    description = "Allow pods on one worker node to communicate with pods on other worker nodes."
    protocol    = "all"
    source      = var.worker_subnet_cidr_block
    stateless   = "false"
  }

  ingress_security_rules {
    description = "Allow Kubernetes control plane to communicate with worker nodes."
    protocol    = "6"
    source      = var.api_subnet_cidr_block
    stateless   = "false"
  }


  ingress_security_rules {
    description = "Path discovery."
    icmp_options {
      code = "4"
      type = "3"
    }
    protocol  = "1"
    source    = "0.0.0.0/0"
    stateless = "false"
  }

  ingress_security_rules {
    description = "Allow inbound SSH traffic to managed nodes."
    protocol    = "6"
    source      = var.worker_subnet_cidr_block
    stateless   = "false"
    tcp_options {
      min = 22
      max = 22
    }
  }

  # # IMPORTANT!!!
  # https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengcreatingnetworkloadbalancers.htm#contengcreatingnetworkloadbalancer_topic-Preserve_source_destination
  ingress_security_rules {
    description = "Load balancer to worker nodes node ports."
    protocol    = "6"
    source      = var.service_subnet_cidr_block
    stateless   = "false"
    tcp_options {
      min = 30000
      max = 32767
    }
  }

  ingress_security_rules {
    description = "Allow load balancer to communicate with kube-proxy on worker nodes."
    protocol    = "6"
    source      = var.service_subnet_cidr_block
    stateless   = "false"
    tcp_options {
      min = 10256
      max = 10256
    }
  }

  # Egress
  egress_security_rules {
    description      = "Allow pods on one worker node to communicate with pods on other worker nodes."
    destination      = var.worker_subnet_cidr_block
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
    stateless        = "false"
  }

  egress_security_rules {
    description      = "Path discovery"
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    icmp_options {
      code = "4"
      type = "3"
    }
    protocol  = "1"
    stateless = "false"
  }

  egress_security_rules {
    description      = "Allow worker nodes to communicate with OKE."
    destination      = oci_core_service_gateway.oke_service_gateway.services.0.service_name
    destination_type = "SERVICE_CIDR_BLOCK"
    protocol         = "6"
    stateless        = "false"
  }

  egress_security_rules {
    description      = "Kubernetes worker to Kubernetes API endpoint communication."
    destination      = var.api_subnet_cidr_block
    destination_type = "CIDR_BLOCK"
    protocol         = "6"
    tcp_options {
      min = 6443
      max = 6443
    }
    stateless = "false"
  }

  egress_security_rules {
    description      = "Kubernetes worker to control plane communication."
    destination      = var.api_subnet_cidr_block
    destination_type = "CIDR_BLOCK"
    protocol         = "6"
    tcp_options {
      min = 12250
      max = 12250
    }
    stateless = "false"
  }

  egress_security_rules {
    description      = "Allow worker nodes to communicate with internet."
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "6"
    stateless        = "false"
  }
  vcn_id = oci_core_vcn.oke_vcn.id

}

resource "oci_core_security_list" "api_endpoint_sec_list" {
  compartment_id = oci_identity_compartment.compartment.id
  display_name   = "oke-prv-api-sl"



  ingress_security_rules {
    description = "Kubernetes worker to Kubernetes API endpoint communication"
    protocol    = "6"
    source      = var.worker_subnet_cidr_block
    stateless   = "false"
    tcp_options {
      min = 6443
      max = 6443
    }
  }

  ingress_security_rules {
    description = "Kubernetes worker to control plane communication."
    protocol    = "6"
    source      = var.worker_subnet_cidr_block
    stateless   = "false"
    tcp_options {
      min = 12250
      max = 12250
    }
  }

  ingress_security_rules {
    description = "Path discovery"
    source      = var.worker_subnet_cidr_block
    icmp_options {
      code = "4"
      type = "3"
    }
    protocol  = "1"
    stateless = "false"
  }

  ingress_security_rules {
    description = "External access to Kubernetes API endpoint."
    protocol    = "6"
    source      = "0.0.0.0/0"
    stateless   = "false"
    tcp_options {
      min = 6443
      max = 6443
    }

  }

  egress_security_rules {
    description      = "Allow Kubernetes Control Plane to communicate with OKE"
    destination      = oci_core_service_gateway.oke_service_gateway.services.0.service_name
    destination_type = "SERVICE_CIDR_BLOCK"
    protocol         = "6"
    stateless        = "false"
  }

  egress_security_rules {
    description = "Path discovery"
    icmp_options {
      code = "4"
      type = "3"
    }
    protocol         = "1"
    destination      = oci_core_service_gateway.oke_service_gateway.services.0.service_name
    destination_type = "SERVICE_CIDR_BLOCK"

    stateless = "false"
  }

  egress_security_rules {
    description      = "Allow Kubernetes control plane to communicate with worker nodes."
    destination      = var.worker_subnet_cidr_block
    destination_type = "CIDR_BLOCK"
    protocol         = "6"
    stateless        = "false"
  }

  egress_security_rules {
    description = "Path discovery"
    icmp_options {
      code = "4"
      type = "3"
    }
    protocol         = "1"
    destination      = var.worker_subnet_cidr_block
    destination_type = "CIDR_BLOCK"

    stateless = "false"
  }

  vcn_id = oci_core_vcn.oke_vcn.id
}

