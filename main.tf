resource "aws_s3_bucket" "agency_bucket" {
  bucket = "agency-data-bucket"

  tags = {
    Name        = "Agency Data Bucket"
    Environment = "Production"
  }
}

resource "aws_s3_bucket_versioning" "agency_bucket" {
  bucket = "agency-data-bucket"
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "agency_bucket" {
    bucket = "agency-data-bucket"
  
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

resource "aws_transfer_server" "sftp_server" {
  identity_provider_type = "SERVICE_MANAGED"
  endpoint_type          = "PUBLIC"
}

resource "aws_iam_role" "transfer_role" {
  name = "TransferRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "transfer.amazonaws.com"
        },
        Action: "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "transfer_policy" {
  name = "TransferPolicy"
  role = aws_iam_role.transfer_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ],
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket_versioning.agency_bucket.bucket}"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ],
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket_versioning.agency_bucket.bucket}/*"
        ]
      }
    ]
  })
}

resource "aws_transfer_user" "agency_user" {
  for_each      = var.agencies
  user_name     = each.key
  server_id     = aws_transfer_server.sftp_server.id
  role          = aws_iam_role.transfer_role.arn

  home_directory_type = "LOGICAL"
  home_directory_mappings {
    entry  = "/${each.key}"
    target = "/${aws_s3_bucket_versioning.agency_bucket.bucket}/${each.key}"
  }
}

resource "aws_transfer_ssh_key" "example" {
  for_each = var.agencies
  server_id = aws_transfer_server.sftp_server.id
  user_name = each.key
  body      = each.value.ssh_public_key
}

