module "vpc_endpoints_sg" {
  source = "../modules/aws/security_group"

  name        = "vpc_endpoints_sg-${var.environment}"
  description = "Allow HTTPS from private subnets to VPC endpoints"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      description = "Allow HTTPS from VPC"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      cidr_ipv4   = var.vpc_cidr
    }
  ]

  tags = { "Name" : "vpc_endpoints_sg-${var.environment}" }
}

module "vpc" {
  source     = "../modules/aws/vpc"
  environment = var.environment
  
  vpc_cidr   = var.vpc_cidr
  aws_region = var.aws_region
}

module "iam" {
  source = "../modules/aws/iam"
  environment = var.environment
}

module "secrets" {
  source            = "../modules/aws/secrets"
  environment = var.environment

  rabbitmq_user     = var.rabbitmq_user
  rabbitmq_password = var.rabbitmq_password

  inventory_db_user     = var.inventory_db_user
  inventory_db_password = var.inventory_db_password
  inventory_db_name     = var.inventory_db_name

  billing_db_user     = var.billing_db_user
  billing_db_password = var.billing_db_password
  billing_db_name     = var.billing_db_name
}


module "cognito" {
  source                  = "../modules/aws/cognito"
  environment = var.environment

  aws_region              = var.aws_region
  # alb_dns_name            = module.alb.alb_dns_name
  security_group_id       = module.aws_gateway_sg.id
  private_subnet_ids      = [module.vpc.private_subnet_ids[0]]
  # alb_listener_arn        = module.alb.alb_listener_arn

  domain_name             = var.domain_name
  cert_arn                = var.cert_arn
  # cert_validation_details = module.acm.cert_validation_details
  enable_custom_domain = var.enable_custom_domain
}
