inputs = {
  environment          = local.environment
  instance_type        = local.instance_type
  enable_custom_domain = true
}

locals {
  environment   = "staging"
  instance_type = "t3.small"
}
