terraform {
  source = "${dirname(find_in_parent_folders("root.hcl"))}//foundation-source"
}

include "env" {
  path = find_in_parent_folders("env.hcl")
}

locals {
  rabbitmq_user         = get_env("RABBITMQ_USER")
  rabbitmq_password     = get_env("RABBITMQ_PASS")

  inventory_db_user     = get_env("INVENTORY_DB_USER")
  inventory_db_password = get_env("INVENTORY_DB_PASS")
  inventory_db_name     = "inventory_db"

  billing_db_user       = get_env("BILLING_DB_USER")
  billing_db_password   = get_env("BILLING_DB_PASS")
  billing_db_name       = "billing_db"
}