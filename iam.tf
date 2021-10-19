data "aws_caller_identity" "admin" {
  provider = aws.admin
}

data "aws_iam_policy_document" "deploy_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.admin.account_id}:root"]
    }
  }
}

data "aws_iam_policy_document" "frontend_deploy_policy" {
  statement {
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.frontend_bucket.arn]
    effect    = "Allow"
  }

  statement {
    actions   = ["s3:PutObject", "s3:PutObjectAcl", "s3:GetObject", "s3:DeleteObject"]
    resources = ["${aws_s3_bucket.frontend_bucket.arn}/*"]
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "frontend_deploy_policy" {
  name        = "FrontendDeploy"
  description = "Deploy frontend code"
  policy      = data.aws_iam_policy_document.frontend_deploy_policy.json
}

resource "aws_iam_role" "deploy_role" {
  name                = "Deploy"
  assume_role_policy  = data.aws_iam_policy_document.deploy_assume_role_policy.json
  managed_policy_arns = [aws_iam_policy.frontend_deploy_policy.arn]
}

output "deploy_role_arn" {
  value = aws_iam_role.deploy_role.arn
}
