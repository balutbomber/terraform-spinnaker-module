resource "aws_codepipeline" "this" {
  name     = var.full_name
  role_arn = var.codepipeline_role_arn

  artifact_store {
    location = var.aws_s3_bucket_artifacts_bucket
    type     = "S3"
    encryption_key {
      id   = var.aws_kms_alias_this_arn
      type = "KMS"
    }
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = var.github_configuration
    }
  }

  stage {
    name = "Build_Cluster"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_cluster_output"]
      version          = "1"

      configuration = {
        ProjectName = var.aws_codebuild_project_this_name
      }
    }
  }

  # stage {
  #   name = "Approve"

  #   action {
  #     name     = "Approval"
  #     category = "Approval"
  #     owner    = "AWS"
  #     provider = "Manual"
  #     version  = "1"

  #     # configuration {
  #     #   CustomData = "A comment"
  #     #   ExternalEntityLink = "http://example.com"
  #     # }
  #   }
  #}

  # stage {
  #   name = "Provision EKS"

  #   action {
  #     name             = "Build"
  #     category         = "Build"
  #     owner            = "AWS"
  #     provider         = "CodeBuild"
  #     input_artifacts  = ["demo-docker-source"]
  #     output_artifacts = ["demo-docker-build"]
  #     version          = "1"

  #     configuration = {
  #       ProjectName = aws_codebuild_project.demo.name
  #     }
  #   }
  # }
}


