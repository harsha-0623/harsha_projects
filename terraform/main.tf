# Specify the required Terraform version
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  required_version = ">= 1.0.0"
}

# Provider configuration
provider "aws" {
  region = "us-east-1"  # Change this to your desired AWS region
}

# Security Group
resource "aws_security_group" "launch_wizard_22" {
  name        = "launch-wizard-22"
  description = "Allow SSH and HTTP traffic"

  ingress {
    from_port   = 22    # Allow SSH
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Change this to your IP range for security
  }

  ingress {
    from_port   = 80    # Allow HTTP
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Change this to your IP range for security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# IAM Role
resource "aws_iam_role" "ec2_role" {
  name               = "my_ec2_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Effect    = "Allow"
      Sid       = ""
    }]
  })
}

# IAM Policy
resource "aws_iam_policy" "ec2_policy" {
  name        = "my_ec2_policy"
  description = "Policy for EC2 instance to access necessary resources"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
          "s3:ListBucket",
          "s3:GetObject"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# IAM Role Policy Attachment
resource "aws_iam_role_policy_attachment" "attach_ec2_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_policy.arn
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "my_ec2_instance_profile"
  role = aws_iam_role.ec2_role.name
}

# EC2 Instance (initial instance)
resource "aws_instance" "my_instance" {
  ami                    = "ami-0f911b9cae0e658cc"  # Your AMI ID
  instance_type          = "t2.micro"               # Change this to your desired instance type

  # Key pair for SSH access (replace with your key name)
  key_name              = "harsha-pem"

  # Attach the security group
  vpc_security_group_ids = [aws_security_group.launch_wizard_22.id]

  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name

  tags = {
    Name = "MyEC2Instance"
  }
}

# Launch Template for Auto Scaling
resource "aws_launch_template" "app_launch_template" {
  name_prefix = "app-launch-template-"
  image_id    = "ami-0f911b9cae0e658cc"  # Your AMI ID
  instance_type = "t2.micro"
  key_name      = "harsha-pem"

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile.name
  }

  # Use the security group ID
  network_interfaces {
    security_groups = [aws_security_group.launch_wizard_22.id]  # Use the security group ID
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "app_asg" {
  desired_capacity     = 2
  max_size             = 3
  min_size             = 1
  vpc_zone_identifier  = ["subnet-06620f15c74b2649b", "subnet-00e89a25c2f50e711"]  # Your actual subnet IDs

  launch_template {
    id      = aws_launch_template.app_launch_template.id
    version = "$Latest"  # Use the latest version of the launch template
  }

  health_check_type    = "EC2"  # Or "ELB" if using an Elastic Load Balancer
  force_delete         = true

  tag {
    key                 = "Name"
    value               = "MyEC2Instance"
    propagate_at_launch = true
  }
}
