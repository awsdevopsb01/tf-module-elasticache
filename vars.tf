variable "name" {
  default = "elasticache"
}
variable "engine_version" {}
variable "port_no" {
  default = "6379"
}
variable "env" {}
variable "kms_arn" {}
variable "tags" {}
variable "allow_db_cidr" {}
variable "subnets" {}
variable "vpc_id" {}
variable "node_type" {}
variable "num_node_groups" {}
variable "replicas_per_node_group" {}