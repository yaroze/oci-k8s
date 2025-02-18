# Makefile for Terraform

# Variables
TF_CMD = tofu
TF_DIR = tofu
TF_PLAN = plan.out
TF_K8S_DIR = tofu-k8s

CHECK_ENVVARS = TF_VAR_tenancy_ocid TF_VAR_domain_name TF_VAR_tailscale_client_secret TF_VAR_tailscale_client_id TF_VAR_os_namespace TF_VAR_cf_email TF_VAR_cf_api_token TF_VAR_ssh_public_key TF_VAR_new_compartment_name

# Targets
.PHONY: init plan apply destroy clean k8s checks

all: init plan apply k8s-plan k8s-apply kubeconfig

checks:
	@MISSINGVARS=0; \
	for var in $(CHECK_ENVVARS); do \
		if [ -z "$${!var}" ]; then \
			echo "Error: Environment variable '$$var' is not set."; \
			MISSINGVARS=1; \
		fi; \
	done; \
	if [ $$MISSINGVARS -eq 1 ]; then \
		echo "Not all required environment variables are set."; \
		exit 1; \
	fi; \
	echo "All required environment variables are set."

init: checks
	@echo "Initializing Terraform..."
	cd $(TF_DIR) && $(TF_CMD) init

plan: checks
	@echo "Planning Terraform changes..."
	cd $(TF_DIR) && $(TF_CMD) plan -out=$(TF_PLAN)

apply: checks
	@echo "Applying Terraform changes..."
	cd $(TF_DIR) && $(TF_CMD) plan -out $(TF_PLAN) && $(TF_CMD) apply $(TF_PLAN) && mkdir -p ~/.kube && cp kubeconfig ~/.kube/config

destroy: checks
	@echo "Destroying Terraform-managed infrastructure..."
	cd $(TF_DIR) && $(TF_CMD) destroy

clean:
	@echo "Cleaning up Terraform files..."
	rm -rf $(TF_DIR)/$(TF_DIR) $(TF_DIR)/terraform.tfstate $(TF_DIR)/terraform.tfstate.backup $(TF_DIR)/.terraform.lock.hcl $(TF_DIR)/.terraform
	rm -rf $(TF_K8S_DIR)/$(TF_PLAN) $(TF_K8S_DIR)/terraform.tfstate $(TF_K8S_DIR)/terraform.tfstate.backup $(TF_K8S_DIR)/.terraform.lock.hcl $(TF_K8S_DIR)/.terraform


k8s-clean:
	@echo "Cleaning up Kubernetes Terraform files..."
	rm -rf $(TF_K8S_DIR)/$(TF_PLAN) $(TF_K8S_DIR)/terraform.tfstate $(TF_K8S_DIR)/terraform.tfstate.backup $(TF_K8S_DIR)/.terraform.lock.hcl $(TF_K8S_DIR)/.terraform

k8s-init:
	@echo "Planning Kubernetes resources..."
	cd $(TF_K8S_DIR) && $(TF_CMD) init

k8s-plan: k8s-init
	@echo "Planning Kubernetes resources..."
	cd $(TF_K8S_DIR) && $(TF_CMD) plan -out=$(TF_PLAN)

k8s-apply: k8s-init k8s-plan
	@echo "Applying Kubernetes resources..."
	cd $(TF_K8S_DIR) && $(TF_CMD) apply $(TF_PLAN)

kubeconfig:
	@echo "Copying kubeconfig..."
	mkdir -p ~/.kube && cp $(TF_K8S_DIR)/kubeconfig ~/.kube/config