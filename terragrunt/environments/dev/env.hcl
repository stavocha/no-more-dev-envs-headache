locals {
  environment = "dev1"
  aws_region  = "us-east-1"
  
  # VPC Configuration
  vpc_name    = "dev-vpc"
  vpc_cidr    = "10.0.0.0/16"
  azs         = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  
  # EKS Configuration
  cluster_name    = "dev1-eks-cluster"
  cluster_version = "1.31"
  
  # Node Group Configuration
  node_group_name      = "dev1-node-group"
  node_instance_types  = ["m5.xlarge"]
  node_min_size        = 1
  node_max_size        = 1
  node_desired_size    = 1
  node_disk_size       = 10
  
} 