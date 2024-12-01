provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "storage-user" {
  name = "savannah-bucket"
}

resource "aws_s3_bucket" "example_bucket" {
  bucket        = var.bucket_name
  force_destroy = false
}

resource "aws_s3_bucket_versioning" "example_versioning" {
  bucket = aws_s3_bucket.example_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

data "aws_iam_policy_document" "storage" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [aws_iam_user.storage-user.arn]
    }

    actions = [
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:PutObject",
      "s3:PutObjectAcl",
    ]

    resources = [
      format("arn:aws:s3:::%s/*", var.bucket_name)
    ]
  }

  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [aws_iam_user.storage-user.arn]
    }

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      format("arn:aws:s3:::%s", var.bucket_name),
    ]
  }
}

resource "aws_s3_bucket_policy" "allow_access_by_storage_user" {
  policy = data.aws_iam_policy_document.storage.json
  bucket = aws_s3_bucket.example_bucket.id
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example_bucket" {
  bucket = aws_s3_bucket.example_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
