variable "access" {}

variable "secret" {}

provider "aws" {
  region     = "ap-southeast-1"
  access_key = var.access
  secret_key = var.secret
}
