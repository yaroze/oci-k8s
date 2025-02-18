# OCI-K8s

[![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/yaroze/oci-k8s/archive/refs/tags/deploy_to_oci.zip)

This project deploys a Basic Kubernetes Cluster on OCI, using Terraform.

## Disclaimer
I haven't had any problems with this code. However I'm not responsible if you use it.
If you use it, make sure you know it does what you want and you know what you're doing.

## Prerequisites

- An [Oracle Cloud Infrastructure](https://www.oracle.com/cloud/) account
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [OpenTofu](https://opentofu.org/docs/intro/install/) or [Terraform](https://developer.hashicorp.com/terraform/install)
- [Oracle Cloud Infrastructure CLI](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm) properly configured
- [Helm](https://helm.sh/docs/intro/install/).
- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- A [Cloudflare account token](https://developers.cloudflare.com/fundamentals/api/get-started/create-token/)
- A [Tailscale](https://tailscale.com/kb/1236/kubernetes-operator#prerequisites) account with OAuth credentials


This code will **only** run on OCI.
Meaning, it will require an Oracle Cloud Infrastructure to deploy the code.
It won't work on AWS, GCE, DigitalOcean or any other cloud or on-premises deployment.


## How to use this



**DISCLAIMER** - Before jumping into running `tofu apply`, or clicking the "Deploy to Oracle Cloud" button, be sure of what you're doing.
I'm not responsible for any charges on your credit card, or if anything breaks or goes bananas. You are the sole responsible for this code and you accept these conditions.
This means this software is provided as-is, **without any explicit or implicit warranties**.

If you still agree with these conditions, please proceed.

I'm using [OpenTofu](https://opentofu.org) for this, but it should work fine with Terraform.

For the basic stuff, the following environment variables must be set:
 
| Variable                        | Meaning |
|---------------------------------|---------|
| `TF_VAR_tenancy_ocid`            | The OCID of the Oracle Cloud tenancy where resources will be deployed. |
| `TF_VAR_new_compartment_name`  | The name of a new OCI compartment to be created for organizing resources. |
| `TF_VAR_domain_name`           | The domain name that will be used for deploying the applications and retrieving certificates with Letsencrypt. |
| `TF_VAR_tailscale_client_id`    | The client ID for Tailscale authentication, paired with the client secret. |
| `TF_VAR_tailscale_client_secret` | The client secret for Tailscale authentication, used to connect Oracle Cloud resources to a Tailscale network. |
| `TF_VAR_os_namespace`          | The Object Storage namespace, which uniquely identifies an Oracle Cloud Infrastructure (OCI) tenancy's storage resources. |
| `TF_VAR_cf_email`              | The email associated with a Cloudflare account, used for integrating OCI with Cloudflare services. |
| `TF_VAR_cf_api_token`          | The API token for Cloudflare, allowing Terraform to manage Cloudflare configurations related to OCI. |
| `TF_VAR_ssh_public_key_path`   | The file path to the SSH public key, used for provisioning compute instances with SSH access for Kubernetes. |

These variables will be read by Terraform and used by the IaC code.

This will:
- A BASIC kubernetes cluster
- 2 ARM64 compute instances with 8GB RAM + 2 oCPUs with your SSH public key.
- A VCN on `eu-frankfurt-1` with the CIDR `10.0.0.0/16` with:
    - 3 subnets:

| Description                                   | CIDR Block      | IP Range                     | Within VCN?   |
|-----------------------------------------------|-----------------|------------------------------|---------------|
| CIDR block for the VCN                        | `10.0.0.0/16`   | 10.0.0.0 - 10.0.255.255      | N/A           |
| Public Subnet for Kubernetes API Endpoint     | `10.0.0.0/30`   | 10.0.0.0 - 10.0.0.3          | Yes           |
| Private Subnet for Worker Nodes               | `10.0.1.0/24`   | 10.0.1.0 - 10.0.1.255        | Yes           |
| Public Subnet for Service Load Balancers      | `10.0.2.0/24`   | 10.0.2.0 - 10.0.2.255        | Yes           |
| CIDR block for the pod subnet                 | `10.244.0.0/16` | 10.244.0.0 - 10.244.255.255  | No (Flannel)  |


Additionally, a `mountTarget` will be created in the same worker subnet, assuming you'll want to use the [File Storage Service](https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengcreatingpersistentvolumeclaim_Provisioning_PVCs_on_FSS.htm) on Kubernetes.


If you'd like more customization options, take a look at [Full list of variables](#full-list-of-variables).

### Deploying
For convenience, a `Makefile` has been developed generate the plan and do the deployment.
However, it's expected the above prerequisites have been fulfilled, including setting the environment variables.

The makefile is divided in 8 targets:
- `checks` - Checks if all required variables are set
- `init` - Performs a `tofu init` on the base OCI code
- `plan` - Creates a `tofu plan` on `tofu/plan.out`
- `apply` - Applies the `tofu/plan.out` to OCI
- `destroy` - Performs a `tofu destroy` to cleanup the infrastructure
- `clean` - Cleans the local infrastructure states
- `k8s-plan` - Creates the `tofu plan` for the Kubernetes resources
- `k8s-apply` - Applies the `tofu plan` for the Kubernetes resources
- `kubeconfig` - Copies the kubeconfig file to `~/.kube/config` - 

⚠️ Before applying the Kubernetes code, make sure you have the base code already deployed ⚠️

#### Example execution (<10 min)
```bash
$ export TF_VAR_tenancy_ocid=ocid1.tenancy.oc1..xxxxxxxxx
$ export TF_VAR_new_compartment_name=Kubernetes
$ export TF_VAR_domain_name=example.com
$ export TF_VAR_tailscale_client_id=xxxx
$ export TF_VAR_tailscale_client_secret=tskey-client-xxx-xxx
$ export TF_VAR_os_namespace=xxx
$ export TF_VAR_cf_email="mail@example.com"
$ export TF_VAR_cf_api_token=xxxxx
$ export TF_VAR_ssh_public_key_path="/home/user/.ssh/id_rsa.pub"

$ make apply
All required environment variables are set.
Applying Terraform changes...
cd tofu && tofu plan -out plan.out && tofu apply plan.out && mkdir -p ~/.kube && cp kubeconfig ~/.kube/config
data.local_file.ssh_public_key: Reading...
data.local_file.ssh_public_key: Read complete after 0s [id=xxxxxxx]
data.oci_core_services.all_oci_services[0]: Reading...
data.oci_core_services.all_oci_services[0]: Read complete after 0s [id=CoreServicesDataSource-0]
...
OpenTofu will perform the following actions:

  # data.oci_containerengine_cluster_kube_config.my_cluster_config will be read during apply
  # (config refers to values not yet known)
 <= data "oci_containerengine_cluster_kube_config" "my_cluster_config" {
      + cluster_id = (known after apply)
      + content    = (known after apply)
      + id         = (known after apply)
    }
...
oci_identity_compartment.compartment: Creating...
oci_identity_compartment.compartment: Still creating... [10s elapsed]
oci_identity_compartment.compartment: Creation complete after 10s [id=ocid1.compartment.oc1..xxx]
oci_file_storage_file_system.fs: Creating...
oci_core_vcn.oke_vcn: Creating...
...
Apply complete! Resources: 22 added, 0 changed, 0 destroyed.

Outputs:

k8sCompartmentID = "ocid1.compartment.oc1..xxx"
mountTargetOCID = "ocid1.mounttarget.oc1.eu_frankfurt_1.xxx"
nodesAvailabilityDomain = "EMbB:EU-FRANKFURT-1-AD-3"
workerCIDR = "10.0.1.0/24"

$
```

Having the infrastructure part deployed, we can now start deploying the Kubernetes resources:
```bash
$ make k8s-apply 
data.terraform_remote_state.tofu: Reading...
...
...

kubectl_manifest.sg_backup_object: Creating...
kubectl_manifest.sg_backup_object: Creation complete after 2s [id=/apis/stackgres.io/v1beta1/namespaces/stackgres/sgobjectstorages/stackgres-backups]

Apply complete! Resources: 24 added, 0 changed, 0 destroyed.

$
```



# Full list of variables

| Variable Name                   | Description                                        | Type         | Default Value |
|---------------------------------|----------------------------------------------------|-------------|---------------|
| `tenancy_ocid`                    | The OCID of the root compartment (required).      | `string`     | _None_ (required) |
| `node_fault_domains`            | Fault domains for node placement.                 | `list(string)` | `["FAULT-DOMAIN-1", "FAULT-DOMAIN-2", "FAULT-DOMAIN-3"]` |
| `availability_domain`           | Availability domain.                              | `string`     | `"FRA-AD-3"` |
| `node_availability_domain`      | Node Availability Domain.                        | `string`     | `"EMbB:EU-FRANKFURT-1-AD-3"` |
| `kubernetes_version`            | Kubernetes version.                              | `string`     | `"v1.31.1"` |
| `node_image_ocid`               | The OCID of the image for worker nodes.          | `string`     | `"ocid1.image.oc1.eu-frankfurt-1.aaaaaaaakgfuegvjwbfdy76uzxstxtzbzt64lsec5rxnt2zjrr3wt23pnjgq"` |
| `cluster_name`                  | Name of the Kubernetes cluster.                  | `string`     | `"kube01"` |
| `ssh_public_key_path`           | Path to the public SSH key.                      | `string`     | _None_ (required) |
| `cni_type`                      | CNI type for Kubernetes networking.              | `string`     | `"FLANNEL_OVERLAY"` |
| `vcn_cidr_block`                | CIDR block for the VCN.                          | `string`     | `"10.0.0.0/16"` |
| `worker_subnet_cidr_block`      | Private subnet CIDR for worker nodes.            | `string`     | `"10.0.1.0/24"` |
| `api_subnet_cidr_block`         | Public subnet CIDR for Kubernetes API endpoint.  | `string`     | `"10.0.0.0/30"` |
| `pod_subnet_cidr_block`         | CIDR block for the pod subnet.                   | `string`     | `"10.244.0.0/16"` |
| `service_subnet_cidr_block`     | Public subnet CIDR for service load balancers.   | `string`     | `"10.0.2.0/24"` |
| `new_compartment_name`          | Name of the new OCI compartment.                 | `string`     | `"Kubernetes"` |