
# 👇 Replace with your actual public SSH key
resource "aws_key_pair" "lab_key" {
  key_name   = "lab-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "lab_sg" {
  name        = "lab-env-sg"
  description = "Allow SSH, HTTP, HTTPS, 8080, and 9090"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Get default VPC and subnet
data "aws_vpc" "default" {
  default = true
}


resource "aws_instance" "lab_env" {
  count         = var.instance_count
  ami           = "ami-0160e8d70ebc43ee1"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.lab_key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.lab_sg.id]

  tags = {
    Name = "lab-env-${count.index + 1}"
  }

  root_block_device {
    volume_size = 32
    volume_type = "gp2"
  }
}
