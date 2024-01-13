output "lambda_function_arn" {
  description = "The Amazon Resource Name (ARN) identifying your Lambda function."
  value       = aws_lambda_function.my_lambda_function.arn
}

output "lambda_function_invoke_arn" {
  description = "The ARN to be used for invoking Lambda function from API Gateway."
  value       = aws_lambda_function.my_lambda_function.invoke_arn
}
