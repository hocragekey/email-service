variable "account_id" {

}

provider "aws" {
  region = "us-east-1"
}

# This is the email service lambda definition
resource "aws_lambda_function" "lebweb_email_lambda" {
  function_name = "lebweb_email_lambda"
  handler = "ses-lambda.handler"
  role = "${aws_iam_role.default.arn}"
  runtime = "nodejs6.10"
  filename = "./../dist/ses-lambda.zip"
  source_code_hash = "${base64sha256(file("./../dist/ses-lambda.zip"))}"
}

# This is the email lambda iam definition
resource "aws_iam_role" "default" {
  name = "iam_lebweb_email_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
            "lambda.amazonaws.com",
            "apigateway.amazonaws.com"
          ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# REST API definition
resource "aws_api_gateway_rest_api" "lebweb_email_api" {
  name = "LebWeb Email API"
}

# Endpoint definition
resource "aws_api_gateway_resource" "lebweb_send_email" {
  rest_api_id = "${aws_api_gateway_rest_api.lebweb_email_api.id}"
  parent_id   = "${aws_api_gateway_rest_api.lebweb_email_api.root_resource_id}"
  path_part   = "email"
}

# method POST /hello, lambda email service
resource "aws_api_gateway_method" "email_api_method" {
  rest_api_id = "${aws_api_gateway_rest_api.lebweb_email_api.id}"
  resource_id = "${aws_api_gateway_resource.lebweb_send_email.id}"
  http_method      = "POST"
  authorization = "NONE"
}

# integrating lambda with api method
resource "aws_api_gateway_integration" "email_method_integration" {
  rest_api_id = "${aws_api_gateway_rest_api.lebweb_email_api.id}"
  resource_id = "${aws_api_gateway_resource.lebweb_send_email.id}"
  http_method = "${aws_api_gateway_method.email_api_method.http_method}"
  type = "AWS_PROXY"
  uri = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:118938645536:function:${aws_lambda_function.lebweb_email_lambda.function_name}/invocations"
  integration_http_method = "POST"
}

# deploy the API
resource "aws_api_gateway_deployment" "lebweb_email_api_deployment" {
  rest_api_id = "${aws_api_gateway_rest_api.lebweb_email_api.id}"
  depends_on = ["aws_api_gateway_method.email_api_method"]
  stage_name  = "production"
}

output "prod_url" {
  value = "https://${aws_api_gateway_deployment.lebweb_email_api_deployment.rest_api_id}.execute-api.us-east-1.amazonaws.com/${aws_api_gateway_deployment.lebweb_email_api_deployment.stage_name}"
}
