output "aws_s3_bucket_artifacts_arn" {
  value = aws_s3_bucket.artifacts.arn
}

output "aws_s3_bucket_artifacts_bucket" {
  value = aws_s3_bucket.artifacts.bucket
}

output "aws_s3_bucket_codebuild_cache_arn" {
  value = aws_s3_bucket.codebuild_cache.arn
}

output "aws_s3_bucket_codebuild_cache_bucket" {
  value = aws_s3_bucket.codebuild_cache.bucket
}
