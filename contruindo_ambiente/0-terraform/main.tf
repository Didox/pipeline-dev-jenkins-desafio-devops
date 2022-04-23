provider "aws" {
  region = "us-east-1"
}

variable "ami" {
  type = string
}

variable "ambiente" {
  type = string
}

variable "instance_type" {
  type = string
}

resource "aws_instance" "vm_dev" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = "chave-publica-computador-reserva"
  tags = {
    Name = var.ambiente
  }
  vpc_security_group_ids = [
    aws_security_group.dev.id
  ]
}

resource "aws_security_group" "dev" {
  name        = "acessos_dev"
  description = "acessos_dev inbound traffic"

  ingress = [
    {
      description      = "SSH from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null,
      security_groups : null,
      self : null
    },
    {
      description      = "SSH from VPC"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null,
      security_groups : null,
      self : null
    }
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"],
      prefix_list_ids  = null,
      security_groups : null,
      self : null,
      description : "Libera dados da rede interna"
    }
  ]

  tags = {
    Name = "dev"
  }
}

output "vm_dev" {
  value = [
    "id: ${aws_instance.vm_dev.id}",
    "public_dns: ${aws_instance.vm_dev.public_dns}",
  ]
}
