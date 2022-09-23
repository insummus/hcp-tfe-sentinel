locals {
  tags = {
    owner        = "gs@hashicorp.com"
    Region       = "ap-northeast-2"
    Purpose      = "Destroy test with count"
    ttl          = 1
    Terraform    = true
    TFE          = true
    TFEWorkspace = "great-stone/aws-gettingstarted"
    Name = "GS"
  }
}

provider "aws" {
  region  = "ap-northeast-2"
}

resource "aws_security_group" "ssh" {
  name        = "allow_ssh_from_all"
  description = "Allow SSH port from all"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.tags
}

resource "aws_instance" "example" {
  count = 1
  ami           = "ami-0cf5e0804bc49842e" # amzn2-ami-hvm-2.0.20200207.1-x86_64-gp2
  # instance_type = "m5.xlarge"
  instance_type = "t2.large"
  vpc_security_group_ids = [
    aws_security_group.ssh.id
  ]

  tags = local.tags

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = fileexists(var.privatekey_file) ? file(var.privatekey_file) : var.privatekey
    host        = self.public_ip
  }
}

output "ami" {
  value = aws_instance.example.*.ami
  sensitive = true
}

output "ip" {
  value = aws_instance.example.*.public_ip
  // sensitive = true
}
