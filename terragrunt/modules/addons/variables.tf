variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version of the EKS cluster"
  type        = string
}

variable "cluster_endpoint" {
  type          = string
  description   = "The host of the EKS cluster"
}

# ArgoCD Configuration
variable "enable_argocd" {
  description = "Enable ArgoCD add-on"
  type        = bool
  default     = true
}

# NGINX Ingress Configuration
variable "enable_ingress_nginx" {
  description = "Enable NGINX Ingress Controller add-on"
  type        = bool
  default     = true
}

# External DNS Configuration
variable "enable_external_dns" {
  description = "Enable External DNS add-on"
  type        = bool
  default     = true
}

# External Secrets Configuration
variable "enable_external_secrets" {
  description = "Enable External Secrets add-on"
  type        = bool
  default     = true
}


# Cert Manager Configuration
variable "enable_cert_manager" {
  description = "Enable Cert Manager add-on"
  type        = bool
  default     = true
}

# ArgoCD Namespace Configuration
variable "argocd_namespace" {
  description = "Namespace where ArgoCD is installed"
  type        = string
  default     = "argocd"
}

# Chart Repository Configuration
variable "chart_repo_url" {
  description = "URL of the Git repository containing the Helm charts"
  type        = string
  default     = "https://github.com/stavocha/no-more-dev-env-headaches.git"
}

variable "chart_revision" {
  description = "Git revision (branch/tag/commit) to use for the chart repository"
  type        = string
  default     = "main"
}

variable "chart_path" {
  description = "Path to the Helm chart within the repository"
  type        = string
  default     = "argocd/apps"
}

variable "chart_value_files" {
  description = "List of value files to use with the Helm chart"
  type        = list(string)
  default     = ["values.yaml"]
}