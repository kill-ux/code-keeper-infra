# include "root" {
#   path = find_in_parent_folders("root.hcl")
# }

locals {
  environment   = "staging"
  instance_type = "t3.small"
}

inputs = {
  environment   = local.environment
  instance_type = local.instance_type
}
