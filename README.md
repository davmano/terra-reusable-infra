Terraform Infrastructure Setup
This Terraform configuration provisions a secure, reusable infrastructure in AWS, including a VPC, IAM role, S3 bucket, and EC2 instances, designed for DevOps workflows.
Prerequisites

Terraform >= 1.0.0
AWS CLI configured with appropriate credentials
An AWS account with permissions to create VPCs, subnets, IAM roles, S3 buckets, and EC2 instances

Directory Structure
.
├── main.tf                # Root configuration calling all modules
├── variables.tf           # Input variables
├── outputs.tf             # Outputs for all resources
├── terraform.tfvars       # Variable values for the dev environment
├── provider.tf            # AWS provider configuration
├── modules/
│   ├── vpc/               # VPC module
│   ├── iam/               # IAM module
│   ├── s3/                # S3 module
│   ├── ec2/               # EC2 module

Usage

Initialize Terraform:
terraform init


Preview Changes:
terraform plan -var-file=terraform.tfvars


Apply Changes:
terraform apply -var-file=terraform.tfvars


Destroy Resources (if needed):
terraform destroy -var-file=terraform.tfvars



Configuration

Edit terraform.tfvars to customize the region, environment, CIDR blocks, AMI ID, etc.
For multiple environments, create additional .tfvars files (e.g., prod.tfvars) and apply with:terraform apply -var-file=prod.tfvars



Remote State (Production)
Uncomment and configure the S3 backend in provider.tf for remote state storage:

Create an S3 bucket and DynamoDB table for locking.
Update the backend block with your bucket, key, region, and table name.

Modules

VPC: Creates a VPC with public and private subnets across multiple AZs.
IAM: Creates an EC2 role with S3 access permissions.
S3: Creates a bucket with versioning and a policy allowing EC2 access.
EC2: Deploys instances in private subnets with an IAM role.

Outputs

vpc_id: ID of the created VPC
public_subnet_ids: List of public subnet IDs
private_subnet_ids: List of private subnet IDs
iam_role_arn: ARN of the IAM role
s3_bucket_arn: ARN of the S3 bucket
s3_bucket_name: Name of the S3 bucket
ec2_instance_ids: List of EC2 instance IDs
ec2_public_ips: List of public IPs (if applicable)

Security Features

Private Subnets: EC2 instances are deployed in private subnets for isolation.
IAM Least Privilege: EC2 role has minimal S3 permissions.
S3 Encryption: Server-side encryption enabled by default.
Multi-AZ: Ensures high availability.
Tagging: Environment-aware tags for auditing.

Best Practices

Use remote state storage (S3 + DynamoDB) for team collaboration.
Integrate with CI/CD pipelines (e.g., GitHub Actions, Jenkins).
Enable VPC Flow Logs and AWS CloudTrail for monitoring.
Use least privilege IAM roles for Terraform execution.
Validate AMI IDs for your region.

Example: Adding More Resources
To add a database, create an RDS module and reference VPC outputs:
module "rds" {
  source      = "./modules/rds"
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.private_subnet_ids
  ...
}

Troubleshooting

Ensure AWS credentials are valid.
Verify CIDR blocks don’t overlap with existing VPCs.
Check AMI ID and availability zone names for your region.
Review Terraform logs for resource creation errors.

For questions, refer to the Terraform AWS Provider documentation.

