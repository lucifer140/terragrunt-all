variable "aws_region" {
  type = string
  default = ""
}


variable "eks_cluster_name" {
  type = string
  default = ""
}


variable "eks_env_tag" {
  type = string
  default = ""
}


variable "eks_module_ver" {
  type = string
  default = "v17.0.3"
}

variable "cluster_ver" {
  type = string
  default = ""
}


variable "eks_version" {
  type = string
  default = ""
}


variable "eks_subnets" {
  type = list(string)
  default = []
}

variable "vpc_id" {
  type = string
  default = ""
}

variable "Environment" {
  type = string
  default = ""
}

variable "Zone" {
  type = string
  default = ""
}


variable "fargate_name" {
  type = string
  default = ""
}


