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

module "iam-codepipeline" {
  source     = "./modules/iam-codepipeline"
  account_id = data.aws_caller_identity.current.account_id
  full_name  = local.full_name
  aws_s3_bucket_artifacts_arn = module.s3.aws_s3_bucket_artifacts_arn
  aws_kms_key_this_arn = module.kms.aws_kms_key_this_arn
}

module "codepipeline" {
  source     = "./modules/codepipeline"
  aws_s3_bucket_artifacts_bucket = module.s3.aws_s3_bucket_artifacts_bucket
  aws_kms_alias_this_arn = module.kms.aws_kms_alias_this_arn
  codepipeline_role_arn = module.iam-codepipeline.aws_iam_role_this_arn
  full_name = local.full_name
  github_configuration = var.github_configuration
}
