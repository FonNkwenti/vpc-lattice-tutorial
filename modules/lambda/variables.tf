
variable "function_name" {
  description = "The name of the Lambda function."
  type        = string
}

variable "role_name" {
  description = "The name of the IAM role for the Lambda function."
  type        = string
}

variable "handler" {
  description = "The function within your code that Lambda calls to begin execution."
  type        = string
}

variable "runtime" {
  description = "The runtime environment for the Lambda function."
  type        = string
}

variable "timeout" {
  description = "The amount of time that Lambda allows a function to run before stopping it."
  type        = number
}

variable "memory_size" {
  description = "The amount of memory that your function has access to."
  type        = number
}

variable "subnet_ids" {
  description = "A list of subnet IDs for the Lambda function if it's within a VPC."
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "A list of security group IDs for the Lambda function if it's within a VPC."
  type        = list(string)
  default     = []
}