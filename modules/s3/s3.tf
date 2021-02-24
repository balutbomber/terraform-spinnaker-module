variable "full_name" {}

resource "aws_s3_bucket" "codebuild_cache" {
  bucket = "${var.full_name}-codebuild-cache"
  acl    = "private"
}

resource "aws_s3_bucket" "artifacts" {
  bucket = "${var.full_name}-artifacts"
  acl    = "private"

  lifecycle_rule {
    id      = "clean-up"
    enabled = "true"

    expiration {
      days = 30
    }
  }
}
