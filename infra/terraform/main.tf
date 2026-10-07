module "vpc" {
  source   = "./modules/vpc"
  
  env_name = var.env_name
  vpc_cidr = var.vpc_cidr
  azs      = var.azs
}

module "eks" {
  source   = "./modules/eks"
  
  env_name        = var.env_name
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
}
