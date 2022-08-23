#variabe for RDS

variable "identifier" {
  type    = string
  default = ""
}

variable "db_engine" {
  type    = string
  default = ""
}


variable "db_engine_version" {
  default = ""
}

variable "db_instance_class" {
  type    = string
  default = ""
}


variable "db_name" {
  type    = string
  default = ""
}

variable "db_username" {
  type    = string
  default = ""
}

variable "db_password" {
  type      = string
  sensitive = true
  default   = ""
}

variable "db_port" {
  default = ""
}

variable "db_major_engine_version" {
  default = ""
}

variable "db_parameter_group" {
  default = ""
}

variable "db_subnet_ids" {
  type    = list(string)
  default = []
}


variable "vpc_id" {
  default = ""
}


variable "min_cap" {
  default = ""
}

variable "max_cap" {
  default = ""
}

variable "allowed_cidr_blocks" {
  type    = list(string)
  default = []
}

variable "port_cidr_blocks" {
  type    = list(string)
  default = []
}

variable "rds_db_name" {
  type    = string
  default = ""
}

variable "db_subnet_group_name" {
  type    = string
  default = ""
}

variable "sg_name" {
  type    = string
  default = ""
}

variable "sg_tags" {
  type    = string
  default = ""
}
variable "security_group_tags" {
  type    = string
  default = ""
}
 
variable "kms_key_id" {
  type = string
  default= ""
}

variable "secret_name" {
  type = string
  default= ""
}


variable "master_username" {
  type = string
  default= ""
}


variable "database_name" {
  description = "Name for an automatically created database on cluster creation"
  type        = string
  default     = null
}

# variable "rds_writer_endpoint" {
#   type = string
#   default= ""
# }