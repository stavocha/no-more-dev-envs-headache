variable "environment" {
  description = "Environment name"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version to use for the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the EKS cluster will be deployed"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "node_group_name" {
  description = "Name of the EKS node group"
  type        = string
}

variable "node_instance_types" {
  description = "List of instance types for the EKS node group"
  type        = list(string)
}

variable "node_min_size" {
  description = "Minimum number of nodes in the EKS node group"
  type        = number
}

variable "node_max_size" {
  description = "Maximum number of nodes in the EKS node group"
  type        = number
}

variable "node_desired_size" {
  description = "Desired number of nodes in the EKS node group"
  type        = number
}

variable "node_disk_size" {
  description = "Size of the disk for each node in the EKS node group"
  type        = number
} 