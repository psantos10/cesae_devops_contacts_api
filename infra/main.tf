terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = "eu-west-1"
  access_key = ""
  secret_key = ""
}

resource "aws_instance" "servidor_web_cesae_01" {
  ami           = "ami-0df368112825f8d8f"
  instance_type = "t2.micro"

  tags = {
    Name = "Servidor Web Cesae 01"
  }
}


output "ip_publico_servidor_web_cesae_01" {
  value = aws_instance.servidor_web_cesae_01.public_ip
}
