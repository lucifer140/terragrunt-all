variable "aws_partition" {
  type        = string
  default     = "aws"
  description = "AWS partition: 'aws', 'aws-cn', or 'aws-us-gov'"
}

variable "service_account_name" {
  type        = string
  description = "Kubernetes ServiceAccount name"
  default     = ""
}

variable "service_account_namespace" {
  type        = string
  description = "Kubernetes Namespace where service account is deployed"
  default     = ""
}

variable "permissions_boundary" {
  type        = string
  description = "ARN of the policy that is used to set the permissions boundary for the role."
  default     = null
}

variable "aws_eks_cluster_identifier" {
  type        = string
  default     = ""
}
variable "iam-role-name" {
  type        = string
  default     = ""  
}