provider "aws" {
  region = var.region
}

resource "aws_security_group" "app_security" {
  name        = "app_security"
  description = "app_security"
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

resource "aws_instance" "app" {
  # ami                    = "ami-0e4a9ad2eb120e054"
  ami                    = "ami-0b1f6dadd6c912cca"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.app_security.id]
  key_name               = aws_key_pair.generated_key.key_name
  tags = {
    Name = "terraform-app"
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = tls_private_key.my_key.private_key_pem
  }

  provisioner "file" {
    source      = "app.sh"
    destination = "/tmp/app.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/app.sh",
      "/tmp/app.sh",
    ]
  }
}

variable "service_ports" {
  default = [22, 8080]
}
output "welcome_to_my_app" {
  value = "http://${aws_instance.app.public_ip}:8080"
}
variable "region" {
  default = "ap-northeast-2"
}
resource "tls_private_key" "my_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "generated_key" {
  public_key = tls_private_key.my_key.public_key_openssh
}


