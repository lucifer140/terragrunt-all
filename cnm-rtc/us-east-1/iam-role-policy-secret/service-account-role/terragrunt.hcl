terraform {
    
  source = "../../../../modules//iampolicy-secret-manager"
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
  paths = ["../../eks-cluster/cnm-cluster"]
}
dependency "eks" {
  config_path = "../../eks-cluster/cnm-cluster/"
}

inputs = {
iam-role-name = "service-account-role-secret"
aws_eks_cluster_identifier = dependency.eks.outputs.cluster_oidc_issuer_url
service_account_name = "postgres-db-sa"
service_account_namespace = "cnm"
}
