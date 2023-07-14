module "eks" {
  source                         = "terraform-aws-modules/eks/aws"
  version                        = "~> 19.0"
  cluster_name                   = var.cluster_name
  cluster_version                = var.cluster_version
  cluster_endpoint_public_access = true

  # timeouts {
  #   create = "20m"
  #   update = "20m"
  #   delete = "20m"
  # }

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }
  vpc_id                   = var.vpc_id
  subnet_ids               = var.subnets_id
  control_plane_subnet_ids = var.subnets_id
  # Self Managed Node Group(s)
  self_managed_node_group_defaults = {
    instance_type                          = "t3.medium"
    update_launch_template_default_version = true
    iam_role_additional_policies = {
      AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    }
  }
  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["t3.medium"]
  }
  eks_managed_node_groups = {
    woekers = {
      min_size     = 1
      max_size     = 5
      desired_size = 5

      instance_types = ["t3.medium"]
      capacity_type  = "SPOT"
    }
  }
  # aws-auth configmap
  manage_aws_auth_configmap = true

  # aws_auth_roles = [
  #   {
  #     rolearn  = "arn:aws:iam::66666666666:role/role1"
  #     username = "role1"
  #     groups   = ["system:masters"]
  #   },
  # ]
  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::779882487479:user/tentativafc"
      username = "tentativafc"
      groups   = ["system:masters"]
    }
  ]
  aws_auth_accounts = [
    local.account_id
  ]
  tags = {
    env                                         = "dev"
    terraform                                   = "true"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared",
    "karpenter.sh/discovery"                    = var.cluster_name
  }
}

resource "aws_ec2_tag" "eks_subnets_tags" {
  for_each    = toset(var.subnets_id)
  resource_id = each.value
  key         = "kubernetes.io/cluster/${module.eks.cluster_name}"
  value       = "shared"
}

resource "aws_ec2_tag" "alb_tags" {
  for_each    = toset(var.subnets_id)
  resource_id = each.value
  key         = "kubernetes.io/role/elb"
  value       = "1"
}
