output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}
output "irsa_role_arn" {
  value = module.secrets_irsa.iam_role_arn
}