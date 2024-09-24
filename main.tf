provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.52.0"
    }
      random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
  required_version = ">= 1.1.0"
  backend "s3" {
    bucket = "terraform-tfstate-grupo12-fiap-2024"
    key    = "sql/terraform.tfstate"
    region = "us-east-1"
  }
}




resource "aws_security_group" "rds_security_group" {
  name        = "rds-security-group"
  description = "Security group for RDS"

  // Regra permitindo tráfego de entrada de qualquer origem
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Adicione outras regras de entrada, se necessário

  // Regra padrão permitindo todo tráfego de saída
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "fiap-tech-challenge-rds" {
  engine = "sqlserver-ex"
  engine_version = "15.00.4385.2.v1"
  license_model = "license-included"
  allocated_storage = 20
  instance_class = "db.t3.micro"
  storage_type = "gp2"
  identifier = "fiap-techchallenge-db"
  username = var.db_username
  password = var.db_password
  publicly_accessible = true
  skip_final_snapshot = true
  vpc_security_group_ids = [aws_security_group.rds_security_group.id]

  tags = {
    Name = "fiap-techchallenge"
  }
}