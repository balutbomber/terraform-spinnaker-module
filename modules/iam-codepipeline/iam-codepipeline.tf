variable "account_id" {}
variable "full_name" {}
variable "artifacts_bucket_arn" {}
variable "aws_kms_key_artifacts_arn" {}

locals {
  codepipeline_role_name = join("-", [var.full_name, "codepipline", "role"])
}

resource "aws_iam_role" "this" {
  name = local.codepipeline_role_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

}

data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"
    actions = [
      "s3:*",
    ]
    resources = [
      var.artifacts_bucket_arn,
      "${var.artifacts_bucket_arn}/*",
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
    ]
    resources = [
      "*",
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    resources = [
      "arn:aws:iam::${var.account_id}:role/${local.codepipeline_role_name}",
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "kms:DescribeKey",
      "kms:GenerateDataKey*",
      "kms:Encrypt",
      "kms:ReEncrypt*",
      "kms:Decrypt",
    ]
    resources = [
      var.aws_kms_key_artifacts_arn,
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "codedeploy:*",
      "ecs:*",
    ]
    resources = [
      "*",
    ]
  }
  # statement {
  #   effect = "Allow"
  #   actions = [
  #     "iam:PassRole"
  #   ]
  #   resources = [
  #     aws_iam_role.ecs-task-execution-role.arn,
  #     aws_iam_role.ecs-demo-task-role.arn,
  #   ]
  #   condition {
  #     test     = "StringLike"
  #     variable = "iam:PassedToService"
  #     values   = ["ecs-tasks.amazonaws.com"]
  #   }
  # }
}

resource "aws_iam_role_policy" "this" {
  name   = "codepipeline-policy"
  role   = aws_iam_role.this.id
  policy = data.aws_iam_policy_document.this.json
}


