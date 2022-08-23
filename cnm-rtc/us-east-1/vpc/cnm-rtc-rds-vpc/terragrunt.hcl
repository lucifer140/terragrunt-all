terraform {
#  source = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git"
   source = "../../../../modules//vpc-module/"
  # This module deploys some resources (e.g., AWS Config) across all AWS regions, each of which needs its own provider,
  # which in Terraform means a separate process. To avoid all these processes thrashing the CPU, which leads to network
  # connectivity issues, we limit the parallelism here.
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


inputs = {
name = "vpc_rds_rtc"
  cidr = "10.40.0.0/16"
  azs              = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnets   = ["10.40.1.0/24", "10.40.2.0/24", "10.40.3.0/24"]
  private_subnets  = ["10.40.7.0/24", "10.40.8.0/24", "10.40.9.0/24"]


  enable_nat_gateway     = false
  single_nat_gateway     = false
  one_nat_gateway_per_az = false

  private_dedicated_network_acl = true
  public_dedicated_network_acl  = true

  public_inbound_acl_rules = [
    {
    
        rule_number     = 101
        rule_action     = "allow"
        from_port       = 5432
        to_port         = 5432
        protocol        = "tcp"
        cidr_block = "10.41.0.0/16"
        }
  ]

  public_name_tag  = ["vpc_rds_rtc-public1", "vpc_rds_rtc-public2", "vpc_rds_rtc-public3"]
  private_name_tag = ["vpc_rds_rtc-private1", "vpc_rds_rtc-private2", "vpc_rds_rtc-private3"]

}

