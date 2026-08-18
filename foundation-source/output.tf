output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "private_subnet_azs" {
  value = module.vpc.private_subnet_azs
}

output "service_discovery_namespace_arn" {
  value = module.vpc.service_discovery_namespace_arn
}

output "ecs_execution_role_arn" {
  value = module.iam.ecs_execution_role_arn
}

output "ecs_instance_profile_name" {
  value = module.iam.ecs_instance_profile_name
}

output "secrets_arn" {
  value = module.secrets.cloud_design_credentials_arn
}

output "aws_gateway_sg_id" {
  value = module.aws_gateway_sg.id
}

output "alb_sg_id" {
  value = module.alb_sg.id
}

output "ecs_instance_sg_id" {
  value = module.ecs_instance_sg.id
}

output "gateway_sg_id" {
  value = module.gateway_sg.id
}

output "rabbitmq_sg_id" {
  value = module.rabbitmq_sg.id
}

output "inventory_sg_id" {
  value = module.inventory_sg.id
}
output "inventory_db_sg_id" {
  value = module.inventory_db_sg.id
}

output "billing_sg_id" {
  value = module.billing_sg.id
}

output "billing_db_sg_id" {
  value = module.billing_db_sg.id
}

output "cognito_user_pool_id" {
  description = "The ID of the Cognito User Pool"
  value       = module.cognito.cognito_user_pool_id
}

output "cognito_user_pool_client_id" {
  description = "The Client ID for client applications"
  value       = module.cognito.cognito_user_pool_client_id
}

output "api_gateway_url" {
  description = "The API Gateway endpoint URL"
  value       = module.cognito.api_gateway_url
}

output "cognito_target_domain_name" {
  value = module.cognito.target_domain_name
}



# output "target_group_arn" {
#   type  = string
#   value = module.alb.target_group_arn
# }

# output "alb_arn_suffix" {
#   value = module.alb.arn_suffix
# }

# output "alb_target_group_arn_suffix" {
#   value = module.alb.alb_target_group_arn_suffix
# }


output "api_gateway_id" {
  value = module.cognito.api_gateway_id
}

output "vpc_link_id" {
  value = module.cognito.vpc_link_id
}

output "authorizer_id" {
  value = module.cognito.authorizer_id
}