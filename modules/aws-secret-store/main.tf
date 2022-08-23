module "secrets-manager" {
  source = "lgallard/secrets-manager/aws"
  secrets = {
    feild-encryption-key = {
      description             = "Field Encryption Key"
      recovery_window_in_days = 7
      secret_string           = var.secret_string
      policy                  = null
    },
  }

  tags = {
    Owner       = var.secret_name
  }
}
