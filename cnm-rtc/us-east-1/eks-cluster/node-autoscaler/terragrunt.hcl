terraform {
  #source = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git"
  # source = "git::https://github.com/terraform-aws-modules/terraform-aws-eks.git"
    
  source = "../../../../modules//helm-autoscaler"
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
dependencies {
  paths = ["../..//eks-cluster/cnm-cluster"]
}

inputs = {
   eks_cluster_name = "cnm-rtc-cluster"
   aws_region = "us-east-1"
   auto_scaler_name = "prod-hotel-cluster-autoscaler"
}
