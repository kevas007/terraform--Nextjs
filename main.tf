provider "aws" {

  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}
///
locals {
  ports_in = [
    443,
    80,
    22
  ]
  ports_out = [
    0
  ]
}

resource "aws_security_group" "web-server" {
  name        = "web-server"
  description = "Allow incoming HTTP Connections"
  #   vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = toset(local.ports_in)
    content {
      description = "Web Traffic from internet"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  dynamic "egress" {
    for_each = toset(local.ports_out)
    content {
      description = "Web Traffic to internet"
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  tags = {
    Name = "internetfacing-loadbalancer-sg"
  }
}
///

# resource "aws_security_group" "web-server" {

#     name        = "web-server"
#     description = "Allow incoming HTTP Connections"
#     ingress = [
#     {
#       description      = "HTTPS from VPC"
#       from_port        = 443
#       to_port          = 443
#       protocol         = "tcp"
#       cidr_blocks      = ["0.0.0.0/0"]
#       ipv6_cidr_blocks = ["::/0"]
#     },
#     {
#       description      = "HTTP from VPC"
#       from_port        = 80
#       to_port          = 80
#       protocol         = "tcp"
#       cidr_blocks      = ["0.0.0.0/0"]
#       ipv6_cidr_blocks = ["::/0"]
#     },
#     {
#       description      = "SSH from VPC"
#       from_port        = 22
#       to_port          = 22
#       protocol         = "tcp"
#       cidr_blocks      = ["0.0.0.0/0"]
#       ipv6_cidr_blocks = ["::/0"]
#     }
#   ]


#   egress {
#       from_port        = 0
#       to_port          = 0
#       protocol         = "-1"
#       cidr_blocks      = ["0.0.0.0/0"]
#       ipv6_cidr_blocks = ["::/0"]
#     }

# }
resource "aws_instance" "web-server" {

  ami = "ami-02e136e904f3da870"

  instance_type = "t2.micro"

  key_name = "cluster"

  security_groups = ["${aws_security_group.web-server.name}"]


  user_data = file("userdata.sh")

  tags = {

    Name = "web_instance"

  }

}
