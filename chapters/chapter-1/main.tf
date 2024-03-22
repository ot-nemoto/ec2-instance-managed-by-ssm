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

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "chapter-1"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "chapter-1"
  }
}

resource "aws_instance" "instance" {
  ami           = "ami-0eba6c58b7918d3a1"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet.id

  tags = {
    Name = "chapter-1"
  }
}
