# Call the VPC module
module "vpc" {
  source              = "./modules/vpc"
  region              = var.region
  environment         = var.environment
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones  = var.availability_zones
}

# Call the IAM module for EC2 instance role
module "iam" {
  source           = "./modules/iam"
  region           = var.region
  environment      = var.environment
  role_name        = var.ec2_role_name
  service_principal = "ec2.amazonaws.com"
  policy_document  = {
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:GetObject", "s3:ListBucket"]
        Effect   = "Allow"
        Resource = ["${module.s3.bucket_arn}/*", module.s3.bucket_arn]
      }
    ]
  }
}

# Call the S3 module
module "s3" {
  source            = "./modules/s3"
  region            = var.region
  environment       = var.environment
  bucket_name       = var.s3_bucket_name
  versioning_enabled = var.s3_versioning_enabled
  bucket_policy     = {
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { AWS = module.iam.role_arn }
        Action    = ["s3:GetObject", "s3:ListBucket"]
        Resource  = ["${module.s3.bucket_arn}/*", module.s3.bucket_arn]
      }
    ]
  }
}

# Call the EC2 module
module "ec2" {
  source         = "./modules/ec2"
  region         = var.region
  environment    = var.environment
  vpc_id         = module.vpc.vpc_id
  subnet_ids     = module.vpc.private_subnet_ids # Deploy in private subnets for security
 # ami_id         = var.ec2_ami_id
  instance_type  = var.ec2_instance_type
  instance_count = var.ec2_instance_count
  instance_profile_name = module.iam.instance_profile_name
}
