locals {
  vpc_id                          = var.vpc_id
  private_subnet_ids              = var.private_subnet_ids
  public_subnet_ids               = var.public_subnet_ids
  ecs_execution_role_arn          = var.ecs_execution_role_arn
  ecs_instance_profile_name       = var.ecs_instance_profile_name
  service_discovery_namespace_arn = var.service_discovery_namespace_arn
  private_subnet_azs              = var.private_subnet_azs
  secrets_arn                     = var.secrets_arn

  aws_gateway_sg_id       = var.aws_gateway_sg_id
  alb_sg_id               = var.alb_sg_id
  ecs_instance_sg_id      = var.ecs_instance_sg_id
  gateway_sg_id           = var.gateway_sg_id
  rabbitmq_sg_id          = var.rabbitmq_sg_id
  inventory_sg_id         = var.inventory_sg_id
  inventory_db_sg_id      = var.inventory_db_sg_id
  billing_sg_id           = var.billing_sg_id
  billing_db_sg_id        = var.billing_db_sg_id
}

module "ecs" {
  source                          = "../modules/aws/ecs"
  environment = var.environment

  ecs_execution_role_arn          = local.ecs_execution_role_arn
  ecs_instance_profile_name       = local.ecs_instance_profile_name
  ecs_instance_sg_id              = local.ecs_instance_sg_id
  private_subnet_ids              = local.private_subnet_ids
  public_subnet_ids               = local.public_subnet_ids
  desired_capacity                = 3
  min_size                        = 3
  max_size                        = 8
  service_discovery_namespace_arn = local.service_discovery_namespace_arn
}

# module "inventory_db_instance" {
#   source                    = "../modules/aws/ecs_db_instance"
#   environment = var.environment

#   host_name                 = "inventory-db"
#   iam_instance_profile_name = local.ecs_instance_profile_name
#   security_group_id         = local.ecs_instance_sg_id
#   subnet_id                 = local.private_subnet_ids[0]
#   cluster_name              = module.ecs.cluster_name
#   device_name               = "sdh"
# }

# module "inventory_db_volume" {
#   source            = "../modules/aws/ebs"
#   device_name       = "/dev/sdh"
#   availability_zone = local.private_subnet_azs[0]
#   ebs_size          = 10
#   ebs_type          = "gp3"
#   instance_id       = module.inventory_db_instance.instance_id
#   tags              = { Name = "inventory-db-volume-${var.environment}" }
# }

# module "billing_db_instance" {
#   source                    = "../modules/aws/ecs_db_instance"
#   environment = var.environment

#   host_name                 = "billing-db"
#   iam_instance_profile_name = local.ecs_instance_profile_name
#   security_group_id         = local.ecs_instance_sg_id
#   subnet_id                 = local.private_subnet_ids[0]
#   cluster_name              = module.ecs.cluster_name
#   device_name               = "sdi"
# }

# module "billing_db_volume" {
#   source            = "../modules/aws/ebs"
#   device_name       = "/dev/sdi"
#   availability_zone = local.private_subnet_azs[0]
#   ebs_size          = 10
#   ebs_type          = "gp3"
#   instance_id       = module.billing_db_instance.instance_id
#   tags              = { Name = "billing_db_volume" }
# }


module "dashboard" {
  source           = "../modules/aws/dashboard"
  environment = var.environment

  ecs_cluster_name = module.ecs.cluster_name
}

resource "aws_budgets_budget" "monthly_cost_alert" {
  name         = "monthly-budget-alert-${var.environment}"
  budget_type  = "COST"
  limit_amount = "50"
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = "80"
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = ["mustaphaboutoubdev@gmail.com"]
  }
}

module "alb" {
  source             = "../modules/aws/alb"
  environment = var.environment
  
  alb_sg_id          = local.alb_sg_id
  private_subnet_ids = local.private_subnet_ids
  public_subnet_ids  = local.public_subnet_ids
  vpc_id             = local.vpc_id

  enable_custom_domain = var.enable_custom_domain
}

module "integration" {
  source           = "../modules/aws/integration"
  alb_listener_arn = module.alb.alb_listener_arn
  api_gateway_id   = var.api_gateway_id
  vpc_link_id      = var.vpc_link_id
  authorizer_id    = var.authorizer_id
}
