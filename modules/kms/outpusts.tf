output "key_alias_arn" {
  description = "The arn of the key alias"
  value       = aws_kms_alias.default.arn
}

output "key_arn" {
  description = "The arn of the key"
  value       = aws_kms_key.default.arn
}
