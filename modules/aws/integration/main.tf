# ALB Backend Integration
resource "aws_apigatewayv2_integration" "integration" {
  api_id             = var.api_gateway_id
  integration_type   = "HTTP_PROXY"
  integration_method = "ANY"

  connection_type = "VPC_LINK"
  connection_id   = var.vpc_link_id
  integration_uri = var.alb_listener_arn
}

# Protected Route
resource "aws_apigatewayv2_route" "protected_route" {
  api_id    = var.api_gateway_id
  route_key = "ANY /{proxy+}"

  authorization_type = "JWT"
  authorizer_id      = var.authorizer_id

  target = "integrations/${aws_apigatewayv2_integration.integration.id}"
}