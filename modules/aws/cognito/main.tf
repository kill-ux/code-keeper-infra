# Cognito User Pool
resource "aws_cognito_user_pool" "pool" {
  name = "cloud-design-user-pool-${var.environment}"

  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }
}

# App Client
resource "aws_cognito_user_pool_client" "client" {
  name            = "cloud-design-user-pool-client-${var.environment}"
  user_pool_id    = aws_cognito_user_pool.pool.id
  generate_secret = false

  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]
}

# HTTP API Gateway
resource "aws_apigatewayv2_api" "gateway" {
  name          = "cloud-design-http-api-${var.environment}"
  protocol_type = "HTTP"
}

# Auto-deploying Stage
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.gateway.id
  name        = "$default"
  auto_deploy = true
}

# JWT Authorizer
resource "aws_apigatewayv2_authorizer" "cognito_auth" {
  api_id           = aws_apigatewayv2_api.gateway.id
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]
  name             = "cognito-authorizer"

  jwt_configuration {
    audience = [aws_cognito_user_pool_client.client.id]
    issuer   = "https://cognito-idp.${var.aws_region}.amazonaws.com/${aws_cognito_user_pool.pool.id}"
  }
}

resource "aws_apigatewayv2_vpc_link" "alb_link" {
  name               = "api-gateway-vpc-link-${var.environment}"
  security_group_ids = [var.security_group_id]
  subnet_ids         = var.private_subnet_ids
}

resource "aws_apigatewayv2_domain_name" "custom_domain" {
  count       = var.enable_custom_domain ? 1 : 0
  domain_name = var.domain_name
  domain_name_configuration {
    certificate_arn = var.cert_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_apigatewayv2_api_mapping" "mapping" {
  count       = var.enable_custom_domain ? 1 : 0
  api_id      = aws_apigatewayv2_api.gateway.id
  domain_name = aws_apigatewayv2_domain_name.custom_domain[0].id
  stage       = aws_apigatewayv2_stage.default.id
}
