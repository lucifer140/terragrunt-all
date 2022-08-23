resource "random_password" "db_master_pass" {
  length           = 10
  special          = false
  
}

module "cluster" {
  source  = "git::https://github.com/sagarshrestha24/terraform-aws-rds-aurora.git"
  name           = var.rds_db_name
  engine         = var.db_engine
  engine_version = var.db_engine_version
  instance_class = var.db_instance_class
  instances = {
    writer = {
       instance_class = var.db_instance_class
}
  }
  iam_database_authentication_enabled = false
  vpc_id  = var.vpc_id
  create_db_subnet_group = true
  subnets = var.db_subnet_ids
  kms_key_id = var.kms_key_id
  create_security_group  = true
  database_name = var.database_name
  master_password       = random_password.db_master_pass.result
  master_username       = var.master_username
  allowed_cidr_blocks     = var.allowed_cidr_blocks
  storage_encrypted   = true
  apply_immediately   = true
  
  port = var.db_port
  autoscaling_enabled      = true
  autoscaling_min_capacity = var.min_cap
  autoscaling_max_capacity = var.max_cap

  
  create_random_password = false
  publicly_accessible = false
  create_monitoring_role = false
  db_subnet_group_name   = var.db_subnet_group_name
}

module "secrets-manager" {
  source = "lgallard/secrets-manager/aws"
  secrets = {
    postgres-rds-url-credential = {
      description             = "Postgres credentials"
      recovery_window_in_days = 7
      secret_string           = format("postgres://%s:%s@%s:5432/%s", "cnm_rtc_app", random_password.db_master_pass.result, module.cluster.cluster_endpoint, "cnm_rtc_app")
      policy                  = null
    },
  }

  tags = {
    Owner       = var.secret_name
  }
}