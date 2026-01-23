# OCI Kubernetes Infrastructure

[![CI Status](https://codeberg.org/yaroze/oci-k8s/actions/workflows/tofu-tests.yaml/badge.svg)](https://codeberg.org/yaroze/oci-k8s/actions?workflow=tofu-tests.yaml)

A comprehensive Terraform/OpenTofu solution for deploying production-ready Kubernetes clusters on Oracle Cloud Infrastructure (OCI) with integrated application bootstrapping and database management via StackGres.

## Architecture Overview

This project provides three modular deployment components:

- **Base Infrastructure**: Core Kubernetes cluster with networking, security, and node pools
- **Bootstrap Applications**: Essential cluster services (ingress, DNS, certificates, monitoring)
- **StackGres Database**: PostgreSQL cluster management with high availability

## Quick Deploy

### Stable (Latest Release)

| Component | Deploy |
|-----------|--------|
| Base Kubernetes Infrastructure | [![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/yaroze/oci-k8s/releases/latest/download/base.zip) |
| Bootstrap Applications | [![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/yaroze/oci-k8s/releases/latest/download/bootstrap.zip) |
| StackGres Database | [![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/yaroze/oci-k8s/releases/latest/download/stackgres.zip) |

### Development (Dev Branch)

| Component | Deploy |
|-----------|--------|
| Base Kubernetes Infrastructure | [![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/yaroze/oci-k8s/releases/download/dev/base.zip) |
| Bootstrap Applications | [![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/yaroze/oci-k8s/releases/download/dev/bootstrap.zip) |
| StackGres Database | [![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/yaroze/oci-k8s/releases/download/dev/stackgres.zip) |

## Documentation

Comprehensive deployment guides are available in the following series:

- [Part 1: Base Infrastructure Setup](https://medium.com/@plfarinha/automatically-deploying-a-basic-kubernetes-cluster-on-oracle-cloud-for-stackgres-d1ada61c46e2)
- [Part 2: Application Bootstrap](https://medium.com/@plfarinha/deploying-a-basic-kubernetes-cluster-on-oracle-cloud-for-stackgres-part-2-bc6d281cd2bf)
- [Part 3: StackGres Configuration](https://medium.com/@plfarinha/deploying-a-basic-kubernetes-cluster-on-oracle-cloud-for-stackgres-part-3-4d5bda66c48b)

## Prerequisites

- Oracle Cloud Infrastructure account with PAYG (Pay As You Go) subscription
- Appropriate IAM permissions for resource creation
- Basic understanding of Kubernetes and Terraform concepts

## Features

- **Production-Ready**: Secure networking, RBAC, and monitoring included
- **Modular Design**: Deploy components independently based on requirements
- **Cost-Optimized**: Designed to minimize OCI costs while maintaining functionality
- **Automated SSL**: Integrated cert-manager with Let's Encrypt
- **Private Networking**: Secure cluster communication with proper network segmentation

## Support

For questions, issues, or feature requests, please [open an issue](https://github.com/yaroze/oci-k8s/issues) on GitHub.

## Disclaimer

This project is provided as-is for educational and development purposes. While designed with best practices in mind, please review and test thoroughly before using in production environments. The author is not responsible for any costs, data loss, or issues that may arise from using this code.

## License

This project is licensed under the terms specified in the [LICENSE](LICENSE) file.
