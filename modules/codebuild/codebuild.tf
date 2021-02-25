# code build
resource "aws_codebuild_project" "this" {
  name           = var.full_name
  description    = "A codebuild project for ${var.full_name}"
  build_timeout  = "30"
  service_role   = var.aws_iam_role_codebuild_arn
  encryption_key = var.aws_kms_alias_this_arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = var.image
    type            = "LINUX_CONTAINER"
    privileged_mode = true

    dynamic "environment_variable" {
      for_each = var.environment_variables

      content {
        name = environment_variable.key
        value = environment_variable.value
      }
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = var.buildspec
  }
}

