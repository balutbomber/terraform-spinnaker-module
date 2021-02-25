variable "account_id" {}

variable "aws_iam_role_codebuild_arn" {}

variable "aws_kms_alias_this_arn" {}

variable "buildspec" {}

variable "environment_variables" {
  type = "map"
  description = "a map of the environment variables for the codebuild project"
  default = {}
}

variable "full_name" {}

variable "image" {
  default = "aws/codebuild/standard:5.0"
}



