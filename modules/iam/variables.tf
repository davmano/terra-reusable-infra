variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "role_name" {
  description = "Name of the IAM role"
  type        = string
}

variable "service_principal" {
  description = "Service principal for assume role (e.g., ec2.amazonaws.com)"
  type        = string
  default     = "ec2.amazonaws.com"
}

variable "policy_document" {
  description = "IAM policy document in JSON format"
  type        = any
}
