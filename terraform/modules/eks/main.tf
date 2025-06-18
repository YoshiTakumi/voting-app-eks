module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.5"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  subnet_ids      = var.subnet_ids
  vpc_id          = var.vpc_id

  enable_irsa               = var.enable_irsa
  authentication_mode       = "API"
  eks_managed_node_groups = {
    yorgos = {
      desired_size    = var.desired_size
      max_size        = var.max_size
      min_size        = var.min_size
      instance_types  = var.instance_types
      capacity_type   = var.capacity_type
    }
  }

  tags = {
    Environment = "dev"
    Project     = var.cluster_name
  }
}


module "ebs_csi_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name             = "ebs-csi-irsa-role"
  attach_ebs_csi_policy = true

  oidc_providers = {
    main = {
      provider_arn = module.eks.oidc_provider_arn
      namespace_service_accounts = [
        "kube-system:ebs-csi-controller-sa"
      ]
    }
  }

  tags = var.tags
}
resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name             = module.eks.cluster_name
  addon_name               = "aws-ebs-csi-driver"
  service_account_role_arn = module.ebs_csi_irsa_role.iam_role_arn

  depends_on = [ module.eks, module.ebs_csi_irsa_role ]
}