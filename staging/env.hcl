inputs = {
  environment          = local.environment
  instance_type        = local.instance_type
  enable_custom_domain = true
  domain_name          = local.domain_name
}

locals {
  environment   = "staging"
  instance_type = "t3.small"
  domain_name   = "staging.cloud.wecode.ma"
}
