terraform {
   source = "../../../../modules//vpc-peering/"
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
  paths = ["../../vpc/cnm-rtc-eks-vpc", "../../vpc/cnm-rtc-rds-vpc"]
}

dependency "eks_vpc_requester" {
   config_path = "../../vpc/cnm-rtc-eks-vpc"

 }

 dependency "rds_vpc_accepter" {
   config_path = "../../vpc/cnm-rtc-rds-vpc"
  
 }


inputs = {
  requestor_vpc_id = dependency.eks_vpc_requester.outputs.vpc_id
  acceptor_vpc_id  = dependency.rds_vpc_accepter.outputs.vpc_id
  requestor_route = dependency.eks_vpc_requester.outputs.vpc_cidr_block
  acceptor_route = dependency.rds_vpc_accepter.outputs.vpc_cidr_block
  acceptor_region = "us-east-1"
  tags_name = "eks-rds-vpc-peering"

}
