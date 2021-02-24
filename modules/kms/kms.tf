variable "full_name" {}
variable "account_id" {}

data "aws_iam_policy_document" "this" {
  policy_id = "${var.full_name}-key-default-1"
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.account_id}:root"]
    }
    actions = [
      "kms:*",
    ]
    resources = [
      "*",
    ]
  }
}

resource "aws_kms_key" "this" {
  description = "kms key for artifacts"
  policy      = data.aws_iam_policy_document.this.json
}

resource "aws_kms_alias" "artifacts" {
  name          = "alias/${var.full_name}-artifacts"
  target_key_id = aws_kms_key.this.key_id
}

