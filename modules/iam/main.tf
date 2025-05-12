provider "aws" {
  region = var.region
}

resource "aws_iam_role" "main" {
  name = "${var.environment}-${var.role_name}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = var.service_principal
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "main" {
  name   = "${var.environment}-${var.role_name}-policy"
  role   = aws_iam_role.main.id
  policy = jsonencode(var.policy_document)
}
