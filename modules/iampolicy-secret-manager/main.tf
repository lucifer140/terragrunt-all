locals {
  eks_cluster_oidc_issuer = replace(var.aws_eks_cluster_identifier, "https://", "")
}


data "aws_caller_identity" "current" {}



resource "aws_iam_policy" "service_account" {
  name = "iam-policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : ["secretsmanager:GetSecretValue", "secretsmanager:DescribeSecret"],
        "Resource" : ["*"]
      }
    ]
  })
}

data "aws_iam_policy_document" "service_account_assume_role" {
  //count = local.enabled ? 1 : 0

  statement {
    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [format("arn:%s:iam::%s:oidc-provider/%s", var.aws_partition, data.aws_caller_identity.current.account_id, local.eks_cluster_oidc_issuer)]
    }

    condition {
      test     = "StringEquals"
      values   = [format("system:serviceaccount:%s:%s", coalesce(var.service_account_namespace, "*"), coalesce(var.service_account_name, "*"))]
      variable = format("%s:sub", local.eks_cluster_oidc_issuer)
    }

    condition {
      test     = "StringEquals"
      values   = ["sts.amazonaws.com"]
      variable = format("%s:aud", local.eks_cluster_oidc_issuer)
    }
  }
}

resource "aws_iam_role" "service_account" {

  name                 = var.iam-role-name
  assume_role_policy   = data.aws_iam_policy_document.service_account_assume_role.json
  permissions_boundary = var.permissions_boundary
}

resource "aws_iam_role_policy_attachment" "service_account" {
  role       = aws_iam_role.service_account.name
  policy_arn = aws_iam_policy.service_account.arn
}

