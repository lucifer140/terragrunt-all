
output "cluster_id" {
  description = "Name of the EKS cluster resource that is created."
  value       = module.eks.cluster_id
}
output "cluster_oidc_issuer_url" {
  description = "Name of the EKS cluster resource that is created."
  value       = module.eks.cluster_oidc_issuer_url

}
output "oidc_provider_arn" {
  description = "Name of the EKS cluster resource that is created."
  value       = module.eks.oidc_provider_arn

}

output "oidc" {
  description = "The OIDC provider attributes for IAM Role for ServiceAccount"
  value = zipmap(
    ["url", "arn"], 
    [module.eks.cluster_oidc_issuer_url,module.eks.oidc_provider_arn]
  )
}

