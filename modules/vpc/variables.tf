variable "vpc_cidr" {
  description = "CIDR block for the VPC"
}

variable "private_subnet_az1_cidr" {}
variable "private_subnet_az2_cidr" {}
variable "az1" {}
variable "az2" {}


variable "vpc_name" {
    description = "Name for the VPC"
}