provider "aws" {
  region = var.region
}

# Optional: Remote state backend (uncomment and configure for production)
# terraform {
#   backend "s3" {
#     bucket         = "my-terraform-state-bucket"
#     key            = "dev/terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "terraform-locks"
#   }
# }
