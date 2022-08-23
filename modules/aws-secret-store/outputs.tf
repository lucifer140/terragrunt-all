output "secret_arns" {
  description = "Secrets arns map"
  value       = module.secrets-manager.secret_arns
}
