locals {
  full_name = join("-", [var.name, var.stage, random_string.random.result])
  image = "aws/codebuild/standard:5.0"

  codebuild_environment_variables = {
    cluster_name = local.full_name
    module_name = var.name
    region = var.region    
    stage = var.stage
  }
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

module "iam_codepipeline" {
  source     = "./modules/iam_codepipeline"
  account_id = data.aws_caller_identity.current.account_id
  full_name  = local.full_name
  aws_s3_bucket_artifacts_arn = module.s3.aws_s3_bucket_artifacts_arn
  aws_kms_key_this_arn = module.kms.aws_kms_key_this_arn
}

module "iam_codebuild" {
  source     = "./modules/iam_codebuild"
  aws_kms_key_this_arn = module.kms.aws_kms_key_this_arn
  aws_s3_bucket_artifacts_arn = module.s3.aws_s3_bucket_artifacts_arn
  aws_s3_bucket_codebuild_cache_arn = module.s3.aws_s3_bucket_codebuild_cache_arn
  full_name  = local.full_name
}

module "codebuild_terraform_init" {
  source     = "./modules/codebuild"
  account_id = data.aws_caller_identity.current.account_id
  aws_iam_role_codebuild_arn = module.iam_codebuild.aws_iam_role_this_arn
  aws_kms_alias_this_arn = module.kms.aws_kms_alias_this_arn
  buildspec = "init.buildspec.yml"
  environment_variables = local.codebuild_environment_variables
  full_name = join("-", [local.full_name, "init"])
  image = local.image
}

module "codebuild_build_cluster" {
  source     = "./modules/codebuild"
  account_id = data.aws_caller_identity.current.account_id
  aws_iam_role_codebuild_arn = module.iam_codebuild.aws_iam_role_this_arn
  aws_kms_alias_this_arn = module.kms.aws_kms_alias_this_arn
  buildspec = "${var.stage}/.terraform/modules/${var.name}/codebuild/build_cluster.buildspec.yml"
  environment_variables = local.codebuild_environment_variables
  full_name = join("-", [local.full_name, "build", "cluster"])
  image = local.image
}

module "codepipeline" {
  source     = "./modules/codepipeline"
  codebuild_terraform_init_aws_codebuild_project_this_name = module.codebuild_terraform_init.aws_codebuild_project_this_name
  codebuild_build_cluster_aws_codebuild_project_this_name = module.codebuild_build_cluster.aws_codebuild_project_this_name
  aws_s3_bucket_artifacts_bucket = module.s3.aws_s3_bucket_artifacts_bucket
  aws_kms_alias_this_arn = module.kms.aws_kms_alias_this_arn
  codepipeline_role_arn = module.iam_codepipeline.aws_iam_role_this_arn
  full_name = local.full_name
  github_configuration = var.github_configuration
}
