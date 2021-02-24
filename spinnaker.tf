locals {
  full_name = join("-", [var.name, var.stage, random_string.random.result])
}

module "s3" {
  source     = "./modules/s3"
  full_name = local.full_name
}

module "kms" {
  source     = "./modules/kms"
  account_id = data.aws_caller_identity.current.account_id
  full_name = local.full_name
}

# module "iam-codepipeline" {
#   source     = "./modules/iam-codepipeline"
#   full_name  = var.full_name
#   artifacts_bucket_arn = aws_s3_bucket.artifacts.arn
# }

# module "codepipline" {
#   source     = "./modules/codepipeline"
#   NAME   = var.NAME
#   STAGE  = var.STAGE
# }