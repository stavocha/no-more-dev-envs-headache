data "aws_caller_identity" "current-iam" {}

data "aws_eks_cluster" "eks-iam" {
  name = var.cluster_name
}

resource "aws_iam_role" "crossplane_aws_role" {
  name = "crossplane-aws-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current-iam.account_id}:oidc-provider/${replace(data.aws_eks_cluster.eks-iam.identity[0].oidc[0].issuer, "https://", "")}"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringLike = {
            "${replace(data.aws_eks_cluster.eks-iam.identity[0].oidc[0].issuer, "https://", "")}:sub" = "system:serviceaccount:crossplane-system:provider-aws-*"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "crossplane_sqs_policy" {
  role       = aws_iam_role.crossplane_aws_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}

resource "aws_iam_role_policy_attachment" "crossplane_iam_policy" {
  role       = aws_iam_role.crossplane_aws_role.name
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

resource "aws_iam_role_policy_attachment" "crossplane_s3_policy" {
  role       = aws_iam_role.crossplane_aws_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "crossplane_admin_policy" {
  role       = aws_iam_role.crossplane_aws_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}