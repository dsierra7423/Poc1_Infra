variable "app_count" {
  type = number
  default = 1
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "aws_cli_profile" {
  description = "aws profile"
  type        = string
}

variable "domain_name" {
  type    = string
  default = "arsmarty.com"
}

variable "sub_domain_name" {
  type    = string
  default = "api.arsmarty.com"
}