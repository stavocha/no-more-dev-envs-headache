terraform {
  source = find_in_parent_folders("modules/addons")
}

include {
  path = find_in_parent_folders()
  expose = true
}

dependency "eks" {
  config_path = find_in_parent_folders("eks")
  mock_outputs = {
    cluster_name = "cluster-name"
    cluster_endpoint = "https://cluster.endpoint.com"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

inputs = {
  cluster_name         = dependency.eks.outputs.cluster_name
  cluster_version      = include.locals.env.locals.cluster_version
  cluster_endpoint         = dependency.eks.outputs.cluster_endpoint
  environment = include.locals.env.locals.environment
  aws_region  = include.locals.env.locals.aws_region
} 