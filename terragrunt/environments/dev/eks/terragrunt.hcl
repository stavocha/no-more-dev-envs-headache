terraform {
  source = find_in_parent_folders("modules/eks")
}

include {
  path = find_in_parent_folders()
  expose = true
}

dependency "vpc" {
  config_path = find_in_parent_folders("vpc")
  mock_outputs = {
    vpc_id          = "vpc-mock"
    public_subnets  = ["subnet-public1", "subnet-public2", "subnet-public3"]
    private_subnets = ["subnet-private1", "subnet-private2", "subnet-private3"]
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

inputs = {
  environment = include.locals.env.locals.environment
  aws_region  = include.locals.env.locals.aws_region
  vpc_id      = dependency.vpc.outputs.vpc_id
  private_subnets = dependency.vpc.outputs.private_subnets
  public_subnets = dependency.vpc.outputs.public_subnets
  
  cluster_name    = include.locals.env.locals.cluster_name
  cluster_version = include.locals.env.locals.cluster_version
  
  node_group_name      = include.locals.env.locals.node_group_name
  node_instance_types  = include.locals.env.locals.node_instance_types
  node_min_size        = include.locals.env.locals.node_min_size
  node_max_size        = include.locals.env.locals.node_max_size
  node_desired_size    = include.locals.env.locals.node_desired_size
  node_disk_size       = include.locals.env.locals.node_disk_size
} 