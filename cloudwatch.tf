resource "aws_cloudwatch_event_rule" "daily_check" {
  name        = "DailyUploadCheck"
  description = "Triggers Lambda function to check for daily uploads"
  schedule_expression = "rate(1 day)"
}

resource "aws_cloudwatch_event_target" "trigger_lambda" {
  rule = aws_cloudwatch_event_rule.daily_check.name
  target_id = "monitoring_lambda"
  arn = aws_lambda_function.monitoring_lambda.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.monitoring_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_check.arn
}
