# OCI-K8s
## CI Status
[![main status](https://codeberg.org/yaroze/oci-k8s/actions/workflows/tofu-tests.yaml/badge.svg)](https://codeberg.org/yaroze/oci-k8s/actions?workflow=tofu-tests.yaml)

## Base K8s infra
[![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/yaroze/oci-k8s/releases/latest/download/base.zip)

## Bootstrap apps
[![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/yaroze/oci-k8s/releases/latest/download/bootstrap.zip)

## Stackgres
[![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/yaroze/oci-k8s/releases/latest/download/stackgres.zip)

This project deploys a Basic Kubernetes Cluster on OCI, using Terraform.

## Usage
Usage can be found on my Medium articles, but feel free to open an issue if you have any questions :)

[Part 1](https://medium.com/@plfarinha/automatically-deploying-a-basic-kubernetes-cluster-on-oracle-cloud-for-stackgres-d1ada61c46e2)

[Part 2](https://medium.com/@plfarinha/deploying-a-basic-kubernetes-cluster-on-oracle-cloud-for-stackgres-part-2-bc6d281cd2bf)

[Part 3](https://medium.com/@plfarinha/deploying-a-basic-kubernetes-cluster-on-oracle-cloud-for-stackgres-part-3-4d5bda66c48b)

## Disclaimer
I haven't had any problems with this code. However I'm not responsible if you use it.
If you use it, make sure you know it does what you want and you know what you're doing.

I've done my best to keep this deployment free. However, you'll need to upgrade to a PAYG account, as there are resources that aren't available on the Free Tier.
I'll give you an option to choose to deploy them or not.

## How to use

Just click the "Deploy to Oracle Cloud" button. You'll be given options to customize your deployment.