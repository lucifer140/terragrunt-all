provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "auto_scaler" {
 # name       = "my-auto-scaler"
  name       = var.auto_scaler_name
  namespace  = "kube-system"
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
  set {
    name  = "image.repository"
    value = "k8s.gcr.io/autoscaling/cluster-autoscaler"
    type  = "string"
  }
  set {
    name  = "image.tag"
    value = "v1.22.1"
    type  = "string"
  }

}
