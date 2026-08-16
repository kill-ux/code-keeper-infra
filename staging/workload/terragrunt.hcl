terraform {
  source = "${dirname(find_in_parent_folders("root.hcl"))}//workload-source"
}

include "env" {
  path = find_in_parent_folders("env.hcl")
}