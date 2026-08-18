include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../modules/aws/acm"
}

inputs = {
  domain_name                = "cloud.wecode.ma"
  subject_alternative_names  = ["*.cloud.wecode.ma"]
}