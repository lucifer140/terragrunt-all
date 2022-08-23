terraform {
   source = "../../../../modules//rds/"
  extra_arguments "parallelism" {
    commands  = get_terraform_commands_that_need_parallelism()
    arguments = ["-parallelism=2"]
  }
}



include {
  path = find_in_parent_folders()
}

locals {
  # Automatically load common variables shared across all accounts
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))

  # Extract the name prefix for easy access
  name_prefix = local.common_vars.locals.name_prefix
  
  project = local.common_vars.locals.project
  
  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Extract the account_name for easy access
  account_name = local.account_vars.locals.account_name

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Extract the region for easy access
  aws_region = local.region_vars.locals.aws_region


  # A local for more convenient access to the accounts map.
  accounts = local.common_vars.locals.accounts

  # A local for convenient access to the security account root ARN.
}
dependencies {
  paths = ["../../vpc/cnm-rtc-rds-vpc", "../../kms/cnm-kms"]
}

dependency "data_vpc" {
  config_path = "../../vpc/cnm-rtc-rds-vpc"
}

dependency "kms" {
  config_path = "../../kms/cnm-kms/"
}

inputs = {
  secret_name = "${local.project}-secret"
  rds_db_name = "${local.project}-rds"
  identifier = "${local.project}-rds"
  db_engine = "aurora-postgresql"
  db_engine_version = "11.13"
  db_instance_class = "db.t3.medium"
  db_port = "5432"
  db_major_engine_version = "5.7"
  db_parameter_group = "default.aurora-postgresql11"
  database_name = "cnm_rtc_app"
  master_username = "cnm_rtc_app"
  allowed_cidr_blocks     = ["0.0.0.0/0"]
  port_cidr_blocks     = ["0.0.0.0/0"]
  min_cap = 1
  max_cap = 3
  db_subnet_group_name  = "${local.project}-rds-subnet-group"
  sg_name = "${local.project}-rds-sg"
  sg_tags = "${local.project}-rds-sg"
  kms_key_id = dependency.kms.outputs.key_arn
  db_subnet_ids = [dependency.data_vpc.outputs.private_subnets[0], dependency.data_vpc.outputs.private_subnets[1]]
  vpc_id        = dependency.data_vpc.outputs.vpc_id
}
