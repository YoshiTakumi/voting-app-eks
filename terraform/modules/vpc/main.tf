module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    version = "5.1.2"
    name    = var.name
    cidr    = var.cidr_block

    azs                 = var.avail_zones
    private_subnets     = var.private_subnets
    public_subnets      = var.public_subnets
    enable_nat_gateway  = true
    single_nat_gateway  = true

    tags = {
        Name = var.name
    }
}