module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "phoenix-${var.env_name}-vpc"
  cidr = var.vpc_cidr

  azs              = var.azs
  # Dynamically calculate subnets based on the VPC CIDR
  private_subnets  = [for k, v in var.azs : cidrsubnet(var.vpc_cidr, 4, k)]
  public_subnets   = [for k, v in var.azs : cidrsubnet(var.vpc_cidr, 4, k + 3)]
  database_subnets = [for k, v in var.azs : cidrsubnet(var.vpc_cidr, 4, k + 6)]

  # Highly available NAT configuration (One NAT Gateway per AZ)
  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  # Tags required by EKS and Load Balancers
  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
    "karpenter.sh/discovery"          = "phoenix-${var.env_name}"
  }
}
