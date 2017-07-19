provider "aws" {
  region = "us-east-1"
}

resource "aws_lambda_function" "lebweb_email_lambda" {
  function_name = "lebweb_email_lambda"
  handler = "ses-lambda.handler"
  role = "${aws_iam_role.default.arn}"
  runtime = "nodejs6.10"
  filename = "./../dist/ses-lambda.zip"
  source_code_hash = "${base64sha256(file("./../dist/ses-lambda.zip"))}"
}

resource "aws_iam_role" "default" {
  name = "iam_lebweb_email_lambda"

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
}
