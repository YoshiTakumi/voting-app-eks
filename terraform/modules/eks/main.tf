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
    default = {
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

resource "aws_iam_policy" "secrets_access" {
  name        = "secretsmanager-access"
  description = "Allow app to read secrets from Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue"
        ],
        Resource = "*"
      }
    ]
  })
}
module "ebs_csi_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name             = "ebs-csi-irsa-role"
  attach_ebs_csi_policy = true

  # Use the OIDC provider that the EKS module created
  oidc_providers = {
    main = {
      provider_arn = module.eks.oidc_provider_arn
      namespace_service_accounts = [
        # format: "<namespace>:<service-account-name>"
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

  # ensure the cluster and IAM role exist first
  depends_on = [ module.eks, module.ebs_csi_irsa_role ]
}