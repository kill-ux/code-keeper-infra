variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC (must match the foundation stack)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "ecs_execution_role_arn" {
  description = "ARN of the ECS execution role"
  type        = string
}

variable "ecs_instance_profile_name" {
  description = "Name of the ECS instance profile"
  type        = string
}

variable "service_discovery_namespace_arn" {
  description = "ARN of the service discovery namespace"
  type        = string
}

variable "private_subnet_azs" {
  description = "List of availability zones for private subnets"
  type        = list(string)
}

variable "secrets_arn" {
  description = "ARN of the secrets manager"
  type        = string
}

variable "aws_gateway_sg_id" {
  description = "Security group ID for the AWS gateway"
  type        = string
}

variable "alb_sg_id" {
  description = "Security group ID for the ALB"
  type        = string
}

variable "ecs_instance_sg_id" {
  description = "Security group ID for the ECS instances"
  type        = string
}

variable "gateway_sg_id" {
  description = "Security group ID for the gateway"
  type        = string
}

variable "rabbitmq_sg_id" {
  description = "Security group ID for RabbitMQ"
  type        = string
}

variable "inventory_sg_id" {
  description = "Security group ID for the inventory service"
  type        = string
}

variable "inventory_db_sg_id" {
  description = "Security group ID for the inventory database"
  type        = string
}

variable "billing_sg_id" {
  description = "Security group ID for the billing service"
  type        = string
}

variable "billing_db_sg_id" {
  description = "Security group ID for the billing database"
  type        = string
}


variable "api_gateway_image" {
  description = "Full Docker image reference for api-gateway (repo:tag)"
  type        = string
}

variable "inventory_app_image" {
  description = "Full Docker image reference for inventory-app (repo:tag)"
  type        = string
}

variable "billing_app_image" {
  description = "Full Docker image reference for billing-app (repo:tag)"
  type        = string
}

variable "rabbitmq_image" {
  description = "Full Docker image reference for rabbitmq (repo:tag)"
  type        = string
}

variable "postgres_db_image" {
  description = "Full Docker image reference for postgres-db (repo:tag)"
  type        = string
}

variable "domain_name" {

}

variable "enable_custom_domain" {

}

variable "api_gateway_id" {}

variable "vpc_link_id" {}

variable "authorizer_id" {}

variable "environment" {
  
}

variable "bootstrap" {
  type    = bool
  default = false
}