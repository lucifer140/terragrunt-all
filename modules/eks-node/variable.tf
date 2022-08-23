
variable "eks_cluster_name" {
  type = string
  default = ""
}

variable "node_group_name" {
  type = string
  default = ""
}

variable "instance_types" {
  type = string
  default = ""
}

variable "disk_size" {
  type = string
  default = ""
}

variable "max_node_size" {
  
}

variable "min_node_size" {
  
}
variable "desired_size" {
  
}

variable "subnet_ids" {
  type = list(string)
}
variable "ami_type" {
  type = string
  default = ""
}
