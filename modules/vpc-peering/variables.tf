variable "requestor_route"{}
variable "acceptor_route"{}
variable "requestor_vpc_id"{}
variable "acceptor_vpc_id"{}
variable "acceptor_region"{}
variable "auto_accept_peering" {
 type = bool
 default = true
}



variable "tags_name" {
  type   = string
  default = ""
}
