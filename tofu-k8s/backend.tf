data "terraform_remote_state" "tofu" {
  backend = "local"

  config = {
    path = "../tofu/terraform.tfstate"
  }
}
