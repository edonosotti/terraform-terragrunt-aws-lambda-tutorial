variable "aws_profile" {
    description = "The profile name from ~/.aws/configure"
    default = "default"
}

variable "aws_region" {
    description = "The AWS region to deploy the resources into."
    default = "eu-west-1"
}

variable "lambda_log_level" {
    description = "Log level for the Lambda Python runtime."
    default = "DEBUG"
}
