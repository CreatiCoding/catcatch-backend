provider "aws" {
  region = var.region
}

variable "region" {
  default = "ap-northeast-2"
}

// security group
variable "service_ports" {
  default = [22, 3000]
}
resource "aws_security_group" "web_security" {
  name        = "web_security"
  description = "web_security"
  dynamic "ingress" {
    for_each = var.service_ports
    content {
      description      = "Port: ${ingress.value}"
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

// EC2 key pair
resource "tls_private_key" "my_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "generated_key" {
  public_key = tls_private_key.my_key.public_key_openssh
}
// EC2 Instance
resource "aws_instance" "web" {
  # ami                    = "ami-0e4a9ad2eb120e054"
  ami                    = "ami-0b1f6dadd6c912cca"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_security.id]
  key_name               = aws_key_pair.generated_key.key_name
  tags = {
    Name = "terraform-web"
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = tls_private_key.my_key.private_key_pem
  }

  provisioner "local-exec" {
    command     = "chmod +x ./predeploy.sh && bash ./predeploy.sh"
    interpreter = ["/bin/bash", "-c"]
  }

  provisioner "file" {
    source      = "deploy.sh"
    destination = "/tmp/deploy.sh"
  }

  provisioner "file" {
    source      = "output.current.tar"
    destination = "/tmp/output.current.tar"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/deploy.sh",
      "/tmp/deploy.sh",
    ]
  }
}
module "route" {
  source = "./modules/route"

  PUBLIC_IP                 = aws_instance.web.public_ip
  DNS_AWS_ACCESS_KEY_ID     = var.DNS_AWS_ACCESS_KEY_ID
  DNS_AWS_SECRET_ACCESS_KEY = var.DNS_AWS_SECRET_ACCESS_KEY
  ROUTE_WEB_DOMAIN          = "pc.creco-aws.com"
  ROUTE_PRIMARY_DOMAIN      = "creco-aws.com"
}

// 도메인 소유 Account 의 key 환경변수
variable "DNS_AWS_ACCESS_KEY_ID" {
  type = string
}
variable "DNS_AWS_SECRET_ACCESS_KEY" {
  type = string
}

// 접속 경로 output
output "welcome_to_my_web" {
  value = "http://pc.creco-aws.com:3000"
  # value = "http://${aws_instance.web.public_ip}:3000"
}
