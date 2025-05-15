data "aws_region" "current" {}

resource "time_sleep" "wait_for_secret_store" {
  depends_on = [module.eks_blueprints_addons]
  create_duration = "10s"
}

resource "kubectl_manifest" "cluster_secret_store" {
    depends_on = [time_sleep.wait_for_secret_store]

    yaml_body = <<-YAML
      apiVersion: external-secrets.io/v1beta1
      kind: ClusterSecretStore
      metadata:
        name: aws-secret-manager
      spec:
        provider:
          aws:
            service: SecretsManager
            region: ${data.aws_region.current.name}
    YAML
}

# resource "kubectl_manifest" "argocd_github_ssh" {
#     count = var.enable_argocd ? 1 : 0
#     depends_on = [kubectl_manifest.cluster_secret_store]

#     yaml_body = <<-YAML
#       apiVersion: external-secrets.io/v1beta1
#       kind: ExternalSecret
#       metadata:
#         name: argocd-github-ssh
#         namespace: ${var.argocd_namespace}
#         labels:
#           argocd.argoproj.io/secret-type: repository
#       spec:
#         refreshInterval: 5m
#         secretStoreRef:
#           name: aws-secret-manager
#           kind: ClusterSecretStore
#         target:
#           name: argocd-github-ssh
#           template:
#             metadata:
#               labels:
#                 argocd.argoproj.io/secret-type: repository
#             type: Opaque
#             data:
#               type: git
#               url: ${var.chart_repo_url}
#               sshPrivateKey: '{{ .sshPrivateKey | replace "\\\n" "\n" }}'
#         data:
#           - secretKey: sshPrivateKey
#             remoteRef:
#               key: ${var.chart_repo_github_ssh_secret_name}
#     YAML
# }

resource "kubectl_manifest" "argocd_app_of_apps" {
    depends_on = [kubectl_manifest.cluster_secret_store]

    yaml_body = <<-YAML
      apiVersion: argoproj.io/v1alpha1
      kind: Application
      metadata:
        name: app-of-apps
        namespace: ${var.argocd_namespace}
      spec:
        project: default
        source:
          repoURL: ${var.chart_repo_url}
          targetRevision: ${var.chart_revision}
          path: ${var.chart_path}
        destination:
          server: https://kubernetes.default.svc
          namespace: ${var.argocd_namespace}
        syncPolicy:
          automated:
            prune: true
            selfHeal: true
    YAML
}
