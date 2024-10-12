provider "aws" {
  region = "us-west-1"
  # shared_config_files      = ["/home/ubuntu/.aws/config"]
  # shared_credentials_files = ["/home/ubuntu/.aws/credentials"]
  shared_config_files      = ["/root/.aws/config"]
  shared_credentials_files = ["/root/.aws/credentials"]
}

# terraform {
#   backend "s3" {
#     bucket = "value"
#     key = "value"
#     region = "value"
#   }
# }