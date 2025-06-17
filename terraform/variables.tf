variable "region" {
    type = string

}
variable "vpc_name" {
    type = string
}
variable "vpc_cidr" {
    type = string
}
variable "cluster_name" {
    type = string
}
variable "cluster_version" {
  type        = string
}

variable "desired_size" {
  type        = number
}

variable "min_size" {
  type        = number
}

variable "max_size" {
  type        = number
}

variable "instance_types" {
  type        = list(string)
}

variable "capacity_type" {
  type        = string
}
variable "avail_zones" {
  type        = list(string)
}
variable "private_subnets" {
  type        = list(string)
}

variable "public_subnets" {
  type        = list(string)
}

variable "enable_nat_gateway" {
  type        = bool
}

variable "single_nat_gateway" {
  type        = bool
}
variable "enable_irsa" {
  type        = bool
  description = "Enable IAM Roles for Service Accounts (IRSA)"
}
