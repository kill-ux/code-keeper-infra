locals {
  aws_region = "eu-west-3"
  account_id = get_env("AWS_ACCOUNT_ID")
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket         = "code-keeper-infra-tfstate-${local.account_id}-${local.aws_region}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_region
    encrypt        = true
    dynamodb_table = "code-keeper-infra-tflock"
  }
}

generate "provider" {
    path      = "provider.tf"
    if_exists = "overwrite"
    contents  = <<EOF
terraform {
  required_version = ">= 1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "${local.aws_region}"

  default_tags {
    tags = {
      Project = "code-keeper"
    }
  }
}
EOF
}