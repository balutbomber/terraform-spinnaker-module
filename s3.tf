#
# cache s3 bucket
#
resource "aws_s3_bucket" "codebuild-cache" {
  bucket = "spinnaker-codebuild-cache--${var.STAGE}-${random_string.random.result}"
  acl    = "private"
}

resource "aws_s3_bucket" "spinnaker-artifacts" {
  bucket = "spinnaker-artifacts-${var.STAGE}-${random_string.random.result}"
  acl    = "private"

  lifecycle_rule {
    id      = "clean-up"
    enabled = "true"

    expiration {
      days = 30
    }
  }
}

resource "random_string" "random" {
  length  = 8
  special = false
  upper   = false
}
