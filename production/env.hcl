locals {
  environment   = "production"
  instance_type = "t3.small"
}

inputs = {
  environment   = local.environment
  instance_type = local.instance_type
}
