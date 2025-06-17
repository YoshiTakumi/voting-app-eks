variable "name" {
  type        = string
}

variable "cidr_block" {
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