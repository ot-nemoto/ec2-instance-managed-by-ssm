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

resource "aws_instance" "instance" {
  ami           = "ami-0eba6c58b7918d3a1"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private.id

  tags = {
    Name = var.tag_name
  }
}
