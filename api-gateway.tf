resource "aws_api_gateway_rest_api" "krazzybee_api" {
  name = "hello-gateway"
}

resource "aws_api_gateway_resource" "myreq" {
  rest_api_id = aws_api_gateway_rest_api.krazzybee_api.id
  parent_id   = aws_api_gateway_rest_api.krazzybee_api.root_resource_id
  path_part   = "myreq"
}

#resource "aws_api_gateway_resource" "hello" {
#  rest_api_id = aws_api_gateway_rest_api.krazzybee_api.id
#  parent_id   = aws_api_gateway_resource.myreq.id
#  path_part   = "hello"
#}

resource "aws_api_gateway_method" "hello" {
  rest_api_id   = aws_api_gateway_rest_api.krazzybee_api.id
  resource_id   = aws_api_gateway_resource.myreq.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = aws_api_gateway_rest_api.krazzybee_api.id
  resource_id = aws_api_gateway_method.hello.resource_id
  http_method = aws_api_gateway_method.hello.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.krazzybee_lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "krazzybee_api" {
  depends_on = [
    aws_api_gateway_integration.lambda,
  ]

  rest_api_id = aws_api_gateway_rest_api.krazzybee_api.id
  stage_name  = "test"
}

output "base_url" {
  value = aws_api_gateway_deployment.krazzybee_api.invoke_url
}
