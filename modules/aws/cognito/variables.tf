variable "aws_region" {
  type = string
}


variable "security_group_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}


variable "domain_name" {
  type = string
}

variable "cert_arn" {
  type = string
}

variable "enable_custom_domain" {
  type    = bool
}

variable "environment" {
  
}