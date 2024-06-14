resource "aws_lambda_function" "monitoring_lambda" {
  filename         = "lambda_function.zip"
  function_name    = "S3MonitoringFunction"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.8"
  environment {
    variables = {
      BUCKET_NAME  = aws_s3_bucket_versioning.agency_bucket.bucket
      AGENCIES     = join(",", keys(var.agencies))
      SNS_TOPIC_ARN = aws_sns_topic.alerts.arn
    }
  }
}

resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  name   = "lambda_policy"
  role   = aws_iam_role.lambda_execution_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:ListBucket",
          "sns:Publish"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}
