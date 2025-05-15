terraform {
  source = find_in_parent_folders("modules/vpc")
}

include {
  path = find_in_parent_folders()
  expose = true
}

inputs = {
  environment = include.locals.env.locals.environment
  vpc_name    = include.locals.env.locals.vpc_name
  vpc_cidr    = include.locals.env.locals.vpc_cidr
  azs         = include.locals.env.locals.azs
  private_subnets = include.locals.env.locals.private_subnets
  public_subnets  = include.locals.env.locals.public_subnets
  cluster_name    = include.locals.env.locals.cluster_name
  
  # NAT Gateway settings
  enable_nat_gateway = true
  single_nat_gateway = true
  enable_dns_hostnames = true
  
  # Tags
  tags = {
    Environment = include.locals.env.locals.environment
    ManagedBy   = "Terraform"
  }
} 