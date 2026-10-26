
resource "aws_key_pair" "my_key" {
  key_name   = "terra-key-ec2"
  public_key = file("keys/terra-key-ec2.pub")
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_security_group" "my_security_group" {
  name        = "my-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH open"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Http open"
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "App port"
  }

  egress {
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
  }
  tags = {
    Name = "automate-sg"
  }
}

resource "aws_instance" "my-vm" {
  # count           = 2 #meta argument
  for_each = tomap({
    TWS-Junoon-automate-t2 = "t2.micro",
    TWS-Junoon-automate-t3 = "t3.micro"
  })
  depends_on = [aws_security_group.my_security_group, aws_key_pair.my_key]
  key_name        = aws_key_pair.my_key.key_name
  security_groups = [aws_security_group.my_security_group.name]
  instance_type   = each.value
  ami             = var.ec2_ami_id #Amazon Linux
  root_block_device {
    volume_size = var.env == "prd" ? 20 : var.ec2_default_root_storage_size
    volume_type = "gp3"
  }
  tags = {
    Name = each.key
  }
  user_data = file("install_nginx.sh")
}