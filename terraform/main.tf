provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "devops_sg" {
  name        = "devops-pipeline-sg"
  description = "Allow SSH, Jenkins, HTTP"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP - webapp"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devops-pipeline-sg"
  }
}

resource "aws_instance" "devops_node" {
  ami                    = "ami-0b6d9d3d33ba97d99" # Ubuntu 22.04 LTS, us-east-1 - verify this is still current
  instance_type          = "t3.micro"
  key_name               = "PRTKEY"
  vpc_security_group_ids = [aws_security_group.devops_sg.id]

  tags = {
    Name = "devops-pipeline-node"
  }
}

output "public_ip" {
  value = aws_instance.devops_node.public_ip
}