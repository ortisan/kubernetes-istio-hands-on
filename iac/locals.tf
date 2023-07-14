data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}

locals {
  region     = var.region
  account_id = data.aws_caller_identity.current.account_id
  tags = {
    GithubRepo = "k8s-demo"
    GithubOrg  = "ortisan"
  }
}
