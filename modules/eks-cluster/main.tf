module "eks" {
  #source       = "terraform-aws-modules/eks/aws"
  #source       = "../aws-eks"

  source        = "git::https://github.com/nibatandukar/eks-cluser.git"

  cluster_name = var.eks_cluster_name
  cluster_version = var.cluster_ver
  subnets = var.eks_subnets
  vpc_id = var.vpc_id
  enable_irsa = true
  fargate_profiles = {
    coredns-fargate-profile = {
      name = var.fargate_name
      selectors = [
        {
          namespace = "default"
          labels = {
          Environment = var.Environment
          Zone        = var.Zone
        }
        }
      ]
            subnets = var.eks_subnets
    }
  }
  tags = {
    environment = var.eks_env_tag
  }
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token = data.aws_eks_cluster_auth.cluster.token
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      data.aws_eks_cluster.cluster.name
    ]
  }
}
/*

module "eks-cluster-autoscaler" {
  source = "DNXLabs/eks-cluster-autoscaler/aws"
  enabled    = true
  cluster_name                     = module.eks.cluster_id
  cluster_identity_oidc_issuer     = module.eks.cluster_oidc_issuer_url
  cluster_identity_oidc_issuer_arn = module.eks.oidc_provider_arn
   aws_region                       = var.aws_region
}
*/

/*
provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
     # args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.cluster.name]
      args        = ["eks", "get-token", "--cluster-name", var.eks_cluster_name]
      command     = "aws"
    }
  }
}
*/

/*
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
*/
/*
module "eks-cluster-autoscaler" {
#  source  = "lablabs/eks-cluster-autoscaler/aws"
   source  = "../terraform-aws-eks-cluster-autoscaler/"

 # enabled    = false
  helm_repo_url  = "https://kubernetes.github.io/autoscaler"
  cluster_name                     = module.eks.cluster_id
  cluster_identity_oidc_issuer     = module.eks.cluster_oidc_issuer_url
  cluster_identity_oidc_issuer_arn = module.eks.oidc_provider_arn
  depends_on = [module.eks]
}
*/
/*
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "auto_scaler" {
  name       = "my-auto-scaler"
  repository = "https://charts.helm.sh/stable"
  chart      = "cluster-autoscaler"
  #values = [
  #  "${file("values.yaml")}"
  #]
  set {
    name  = "autoDiscovery.clusterName"
    #value = "NONPROD-HOTEL-CLUSTER"
    value = var.eks_cluster_name
    type = "string"
  }
  set {
    name  = "awsRegion"
    #value = "us-west-2"
    value = var.aws_region
    type  = "string"
  }
}

*/
