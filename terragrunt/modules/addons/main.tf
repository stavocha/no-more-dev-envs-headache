data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "eks" {
    name = var.cluster_name
}

data "aws_eks_cluster_auth" "eks" {
    name = var.cluster_name
}

provider "kubernetes" {
  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

provider "helm" {
  kubernetes {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}

# Add EKS Blueprints Add-ons
module "eks_blueprints_addons" {
    source  = "aws-ia/eks-blueprints-addons/aws"
    version = "1.16.3"
    
  cluster_name      = var.cluster_name
  cluster_version   = var.cluster_version
  cluster_endpoint  = var.cluster_endpoint
  oidc_provider_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(data.aws_eks_cluster.eks.identity[0].oidc[0].issuer, "https://", "")}" 

  # Enable ArgoCD
  enable_argocd = true

  # Enable NGINX Ingress Controller
  enable_ingress_nginx = true

  # Enable External DNS
  enable_external_dns = false

  # Enable External Secrets
  enable_external_secrets = true

  # Enable Cert Manager
  enable_cert_manager = false
}