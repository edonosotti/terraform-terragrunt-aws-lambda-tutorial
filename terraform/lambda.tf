# Define a local variable for the Lambda function
# source code path in order to avoid repetitions.
locals {
  # Relative paths change if this configuration is
  # included as a module from Terragrunt.
  lambda_src_path = "${path.module}${var.lambda_relative_path}lambda"
}

# Compute the source code hash, only taking into
# consideration the actual application code files
# and the dependencies list.
resource "random_uuid" "lambda_src_hash" {
  keepers = {
    for filename in setunion(
      fileset(local.lambda_src_path, "*.py"),
      fileset(local.lambda_src_path, "requirements.txt"),
      fileset(local.lambda_src_path, "core/**/*.py")
    ):
    filename => filemd5("${local.lambda_src_path}/${filename}")
  }
}

# Automatically install dependencies to be packaged
# with the Lambda function as required by AWS Lambda:
# https://docs.aws.amazon.com/lambda/latest/dg/python-package.html#python-package-dependencies
resource "null_resource" "install_dependencies" {
  provisioner "local-exec" {
    command = "pip install -r ${local.lambda_src_path}/requirements.txt -t ${local.lambda_src_path}/ --upgrade"
  }

  # Only re-run this if the dependencies or their versions
  # have changed since the last deployment with Terraform
  triggers = {
    dependencies_versions = filemd5("${local.lambda_src_path}/requirements.txt")
    # source_code_hash = random_uuid.lambda_src_hash.result # This is a suitable option too
  }
}

# Create an archive form the Lambda source code,
# filtering out unneeded files.
data "archive_file" "lambda_source_package" {
  type        = "zip"
  source_dir  = local.lambda_src_path
  output_path = "${path.module}/.tmp/${random_uuid.lambda_src_hash.result}.zip"

  excludes    = [
    "${local.lambda_src_path}/__pycache__",
    "${local.lambda_src_path}/core/__pycache__",
    "${local.lambda_src_path}/tests"
  ]
}

# Create an IAM execution role for the Lambda function.
resource "aws_iam_role" "execution_role" {
  name = "lambda-execution-role-zero-provider"

  assume_role_policy = <<EOF
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
EOF

  tags = {
    provisioner = "terraform"
  }
}

# Attach a IAM policy to the execution role to allow
# the Lambda to stream logs to Cloudwatch Logs.
resource "aws_iam_role_policy" "log_writer" {
  name = "lambda-log-writer-zero-provider"
  role = aws_iam_role.execution_role.id

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource": "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# Deploy the Lambda function to AWS
resource "aws_lambda_function" "zero_provider" {
  function_name = "zero-provider"
  description = "Just a stub Lambda function logging multidimensional arrays full of zeros."
  role = aws_iam_role.execution_role.arn
  filename = data.archive_file.lambda_source_package.output_path
  runtime = "python3.8"
  handler = "lambda.handler"
  memory_size = 128
  timeout = 30

  source_code_hash = data.archive_file.lambda_source_package.output_base64sha256

  tags = {
    provisioner = "terraform"
  }

  environment {
    variables = {
      LOG_LEVEL = var.lambda_log_level
    }
  }

  lifecycle {
    # Terraform will any ignore changes to the
    # environment variables after the first deploy.
    ignore_changes = [environment]
  }
}

# The Lambda function would create this Log Group automatically
# at runtime if provided with the correct IAM policy, but
# we explicitly create it to set an expiration date to the streams.
resource "aws_cloudwatch_log_group" "zero_provider" {
  name              = "/aws/lambda/${aws_lambda_function.zero_provider.function_name}"
  retention_in_days = 30
}
