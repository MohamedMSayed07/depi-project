provider "aws" {
  region = "us-west-1"
  shared_config_files      = ["/home/momo/.aws/config"]
  shared_credentials_files = ["/home/momo/.aws/credentials"]
}

# terraform {
#   backend "s3" {
#     bucket = "value"
#     key = "value"
#     region = "value"
#   }
# }