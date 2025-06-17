terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
    region = var.region
}

module "vpc" {
    source  = "./modules/vpc"
    name        = var.vpc_name
    cidr_block  = var.vpc_cidr
    avail_zones = var.avail_zones
    private_subnets = var.private_subnets
    public_subnets  = var.public_subnets
    enable_nat_gateway  = var.enable_nat_gateway
    single_nat_gateway  = var.single_nat_gateway
}

module "eks" {
    source = "./modules/eks"
    cluster_name = var.cluster_name
    region       = var.region
    subnet_ids   = module.vpc.private_subnets
    vpc_id       = module.vpc.vpc_id
    desired_size     = var.desired_size
    min_size         = var.min_size
    max_size         = var.max_size
    cluster_version  = var.cluster_version
    instance_types   = var.instance_types
    capacity_type    = var.capacity_type
    enable_irsa               = var.enable_irsa
}