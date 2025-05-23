region              = "us-east-1"
environment         = "dev"
vpc_cidr            = "10.0.0.0/16"
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
availability_zones  = ["us-east-1a", "us-east-1b"]
ec2_role_name       = "ec2-s3-access"
s3_bucket_name      = "my-app-bucket"
s3_versioning_enabled = true
ec2_ami_id          = "ami-0c55b159cbfafe1f0" # Example Amazon Linux 2 AMI in us-east-1
ec2_instance_type   = "t2.micro"
ec2_instance_count  = 2
