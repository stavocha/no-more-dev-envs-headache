
locals {
  env     = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  cloud_provider = "aws"

  # Extract the variables we need for easy access
  aws_region  = local.env.locals.aws_region
  environment = local.env.locals.environment
}

terraform {
  extra_arguments "retry_lock" {
    commands  = get_terraform_commands_that_need_locking()
    arguments = [
      "-lock-timeout=20m"
    ]
  }
}

# Generate an AWS provider block

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF

  provider "aws" {
    region = "${local.aws_region}"

    # preserve kubernetes tags
    ignore_tags {
      key_prefixes = ["kubernetes.io/*"]
    }
  }

  EOF
}

