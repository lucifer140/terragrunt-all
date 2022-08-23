output "cluster_endpoint" {
  description = "Writer endpoint for the cluster"
  value       = module.cluster.cluster_endpoint
}

output "secret_arns" {
  description = "Secrets arns map"
  value       = module.secrets-manager.secret_arns
}