terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-northeast-1"
}

################################################################################
# Networking
################################################################################
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = var.tag_name
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = var.tag_name
  }
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = aws_vpc.main.id
  subnet_ids          = [aws_subnet.private.id]
  service_name        = "com.amazonaws.ap-northeast-1.ssm"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids = [
    aws_security_group.vpc_endpoint.id,
  ]

  tags = {
    Name = var.tag_name
  }
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id              = aws_vpc.main.id
  subnet_ids          = [aws_subnet.private.id]
  service_name        = "com.amazonaws.ap-northeast-1.ec2messages"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids = [
    aws_security_group.vpc_endpoint.id,
  ]

  tags = {
    Name = var.tag_name
  }
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id              = aws_vpc.main.id
  subnet_ids          = [aws_subnet.private.id]
  service_name        = "com.amazonaws.ap-northeast-1.ssmmessages"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids = [
    aws_security_group.vpc_endpoint.id,
  ]

  tags = {
    Name = var.tag_name
  }
}

resource "aws_security_group" "vpc_endpoint" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.tag_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.vpc_endpoint.id
  cidr_ipv4         = aws_vpc.main.cidr_block
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.vpc_endpoint.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

################################################################################
# Compute
################################################################################
resource "aws_instance" "instance" {
  ami                  = "ami-0eba6c58b7918d3a1"
  instance_type        = "t2.micro"
  subnet_id            = aws_subnet.private.id
  iam_instance_profile = aws_iam_instance_profile.profile.name

  tags = {
    Name = var.tag_name
  }
}

resource "aws_iam_instance_profile" "profile" {
  role = aws_iam_role.role.name
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "role" {
  assume_role_policy  = data.aws_iam_policy_document.assume_role.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
}
