locals {
  lambda_zip_location = "main.zip"
}


resource "aws_lambda_function" "krazzybee_lambda" {
  filename      = "${local.lambda_zip_location}"
  function_name = "hello_lambda"
  role          = "${aws_iam_role.lambda_krazzybee_role.arn}"
  handler       = "main"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"

  source_code_hash = "${filebase64sha256(local.lambda_zip_location)}"
  runtime          = "go1.x"

  #  environment {
  #    variables = {
  #      foo = "bar"
  #    }
  #  }
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.krazzybee_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  # The "/*/*" portion grants access from any method on any resource
  # within the API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.krazzybee_api.execution_arn}/*/*"
}
