terraform {
  #source = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git"
  # source = "git::https://github.com/terraform-aws-modules/terraform-aws-eks.git"
    
  source = "../../../../modules//eks-cluster"
  #source = "/home/ec2-user/infrastructure-automation/fpg-infra/modules/eks-cluster/aws-eks/examples/aws-eks-cluster"
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
  paths = ["../../vpc/cnm-rtc-eks-vpc"]
}

dependency "data_vpc" {
  config_path = "../../vpc/cnm-rtc-eks-vpc"
}

inputs = {
   cluster_ver = "1.21"
 
   eks_subnets = [dependency.data_vpc.outputs.private_subnets[0], dependency.data_vpc.outputs.private_subnets[1], dependency.data_vpc.outputs.private_subnets[2]]
   vpc_id = dependency.data_vpc.outputs.vpc_id
   eks_env_tag = "${local.project}-rtc-cluster"

   eks_cluster_name = "${local.project}-rtc-cluster"
   cluster_ver = "1.21"
   fargate_name = "${local.project}-rtc-fargate"
   Environment = "development"
   Zone        = "test"


}

