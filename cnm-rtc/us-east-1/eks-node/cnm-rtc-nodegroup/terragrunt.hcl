terraform {
    
  source = "../../../../modules//eks-node"
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
  project = local.common_vars.locals.project
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
  paths = ["../../vpc/cnm-rtc-eks-vpc", "../../eks-cluster/cnm-cluster"]
}
dependency "data_vpc" {
  config_path = "../../vpc/cnm-rtc-eks-vpc"
}

inputs = {
   eks_cluster_name = "${local.project}-rtc-cluster"
   node_group_name  = "${local.project}-rtc-nodegroup"
   desired_size     = 1
   max_node_size    = 15
   min_node_size    = 1
   instance_types   = "t3.medium"
   disk_size        = "150"
   ami_type         = "AL2_x86_64"
   subnet_ids       = [dependency.data_vpc.outputs.private_subnets[0], dependency.data_vpc.outputs.private_subnets[1], dependency.data_vpc.outputs.private_subnets[2]]

}

