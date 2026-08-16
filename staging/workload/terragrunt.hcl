include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${dirname(find_in_parent_folders("root.hcl"))}//workload-source"
}

inputs = {
  vpc_id                          = dependency.foundation.outputs.vpc_id
  private_subnet_ids              = dependency.foundation.outputs.private_subnet_ids
  public_subnet_ids               = dependency.foundation.outputs.public_subnet_ids
  ecs_execution_role_arn          = dependency.foundation.outputs.ecs_execution_role_arn
  ecs_instance_profile_name       = dependency.foundation.outputs.ecs_instance_profile_name
  service_discovery_namespace_arn = dependency.foundation.outputs.service_discovery_namespace_arn
  private_subnet_azs              = dependency.foundation.outputs.private_subnet_azs
  secrets_arn                     = dependency.foundation.outputs.secrets_arn
  ecr_registry                    = dependency.foundation.outputs.ecr_registry
  aws_gateway_sg_id               = dependency.foundation.outputs.aws_gateway_sg_id
  alb_sg_id                       = dependency.foundation.outputs.alb_sg_id
  ecs_instance_sg_id              = dependency.foundation.outputs.ecs_instance_sg_id
  gateway_sg_id                   = dependency.foundation.outputs.gateway_sg_id
  rabbitmq_sg_id                  = dependency.foundation.outputs.rabbitmq_sg_id
  inventory_sg_id                 = dependency.foundation.outputs.inventory_sg_id
  inventory_db_sg_id              = dependency.foundation.outputs.inventory_db_sg_id
  billing_sg_id                   = dependency.foundation.outputs.billing_sg_id
  billing_db_sg_id                = dependency.foundation.outputs.billing_db_sg_id
  cert_arn                        = dependency.foundation.outputs.cert_arn
}

dependency "foundation" {
  config_path = "../foundation"

  mock_outputs = {
    vpc_id = "vpc-mock"
    private_subnet_ids = [
      "subnet-mock1", "subnet-mock2"
    ]

    public_subnet_ids = [
      "subnet-mock3", "subnet-mock4"
    ]

    ecs_execution_role_arn          = "arn:aws:iam::000000000000:role/mock"
    ecs_instance_profile_name       = "mock-instance-profile"
    service_discovery_namespace_arn = "arn:aws:servicediscovery:eu-west-3:000000000000:namespace/mock"
    private_subnet_azs = [
      "eu-west-3a", "eu-west-3b"
    ]

    secrets_arn = "arn:aws:secretsmanager:eu-west-3:000000000000:secret:mock"
    ecr_registry = {
      "api-gateway" = "000000000000.dkr.ecr.eu-west-3.amazonaws.com/api-gateway"
      "rabbitmq" = "000000000000.dkr.ecr.eu-west-3.amazonaws.com/rabbitmq"
      "inventory-app" = "000000000000.dkr.ecr.eu-west-3.amazonaws.com/inventory-app"
      "postgres-db" = "000000000000.dkr.ecr.eu-west-3.amazonaws.com/postgres-db"
      "billing-app" = "000000000000.dkr.ecr.eu-west-3.amazonaws.com/billing-app"
    }

    aws_gateway_sg_id  = "sg-mock1"
    alb_sg_id          = "sg-mock2"
    ecs_instance_sg_id = "sg-mock3"
    gateway_sg_id      = "sg-mock4"
    rabbitmq_sg_id     = "sg-mock5"
    inventory_sg_id    = "sg-mock6"
    inventory_db_sg_id = "sg-mock7"
    billing_sg_id      = "sg-mock8"
    billing_db_sg_id   = "sg-mock9"
    cert_arn           = "arn:aws:acm:eu-west-3:000000000000:certificate/mock"
  }

  mock_outputs_allowed_terraform_commands = [
    "plan", "validate"
  ]
}

include "env" {
  path = find_in_parent_folders("env.hcl")
}
