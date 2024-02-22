terraform {
  required_providers {
    densify = {
      source = "densify.com/provider/densify"
    }
  }
}

provider "densify" {
  tech_platform  = "aws" # or can be passed in as env variable: DENSIFY_TECH_PLATFORM
  account_number = var.account_number
  system_name    = var.name
  # fallback_instance_type = "m6i.large"  // backup/fallback instance type until there is a recommendation
}

data "densify_cloud" "optimization" {}

output "data_cloud" {
  value = data.densify_cloud.optimization
}
