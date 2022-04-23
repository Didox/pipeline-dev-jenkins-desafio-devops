provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "vm_fragmento" {
  ami           = "ami-09e67e426f25ce0d7"
  instance_type = "t2.micro"
  key_name      = "chave-publica-computador-reserva"
  tags = {
    Name = "vm-fragmento"
  }
  vpc_security_group_ids = [
    aws_security_group.fragmento.id
  ]
}

resource "aws_security_group" "fragmento" {
  name        = "acessos_fragmento"
  description = "acessos_fragmento inbound traffic"

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
    Name = "fragmento"
  }
}

output "vm_fragmento" {
  value = [
    "id: ${aws_instance.vm_fragmento.id}",
    "public_dns: ${aws_instance.vm_fragmento.public_dns}",
  ]
}
