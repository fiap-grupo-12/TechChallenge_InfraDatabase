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
}

provider "aws" {
  region     = "us-east-1"
  access_key = "ASIA52YBFBLMSIN22EWX"
  secret_key = "HP1KdoaNjmSm+Wkfc/CnOhtkwOMH4gdZcp5pjxwi"
  token = "IQoJb3JpZ2luX2VjEHIaCXVzLXdlc3QtMiJIMEYCIQCz4c/9WDJWdilr7EPgaTP+ixgYu6C+XivVwGPEuJZ9OQIhAMr6CQYt7v7AwwZspwhaOjtbCikHxe0HLRom0FHUHrGSKr8CCKv//////////wEQABoMOTUwODAwODEyNzYxIgwnF6gz1BL6uyZRsOsqkwLTLKQeiDr6hlnfZQU7jzSqwPGjjF/CPGmZwOP6kt/0QvlRGxEZR6ulmVYefhaRBxcIT+FxLeTPjpZWrCQU8LmWVD5OBgUuPTaZjg4bSC+wyVVcezeli+ILD3ZWSDfUkaotuNlENgi28JtlidmUum9C23t/GgLoOszrOpJaaqn/pwJqzMdyJkOX3fF46cX7zkeR8DX5W9zpna0Lc2GcmA85mSojjSVp4gK4hzWZTVDoVU6NcUfiFeY0oL3VnOwiowrSq+LRSQUs3+0jm8zFdKx8Ulw0MuqGHYHMQaX3GkK1aKeg5BIJanYcGP8TEQTZS+nh+mq7xc/NBMqAscdYmW3XeyNMSrHQjyOAvbGXz6duu6pYozD3vMG3BjqcARqMH8BtBg/FDoURGeZjppROUAq6JdtaPFKObgyIHBOmMBGv4qUMBk3KtXGC81lmBNMLnkDLugqRkD8P1O+X5vJpIOGy2vn+e1Skt14GobjMdrDpgL6tz/4BPMeVGnaIv5XrBNOjHiK7ii/h2PloMNY1wu/AmNHMluufyLTX2BNu4nKS0U8p2Zoxxtx1d1qj64kxQRYH0fw1KXE0Jw=="
}

data "aws_subnet" "subnet_1" {
  id = "subnet-03fea9a91c4e2e18f"
}

data "aws_subnet" "subnet_2" {
  id = "subnet-057fd3ea1817640f5"
}

data "aws_subnet" "subnet_3" {
  id = "subnet-0eb1209e772751b6a"
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