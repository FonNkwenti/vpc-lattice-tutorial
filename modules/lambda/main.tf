# provider "aws" {
#   region = var.aws_region
# }

resource "aws_lambda_function" "my_lambda_function" {
  function_name = var.function_name
  role          = var.role_name
  handler       = var.handler
  runtime       = var.runtime
  timeout       = var.timeout
  memory_size   = var.memory_size

  source_code_hash = filebase64("${path.module}/lambda_function.zip")

    vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  depends_on = [aws_iam_role.lambda_execution_role]
}

resource "aws_iam_role" "lambda_execution_role" {
  name = var.role_name

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}
