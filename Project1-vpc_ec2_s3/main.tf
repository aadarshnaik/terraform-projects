resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr_block
  tags = {
    "Name" = "my-vpc"
  }
}

resource "aws_subnet" "sub1" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.sub1_cidr
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "sub1"
  }
}
resource "aws_subnet" "sub2" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.sub2_cidr
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "sub2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "my-igw"
  }
}

resource "aws_route_table" "routeTable" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "my_route"
  }
}

resource "aws_route_table_association" "route_association_sub1" {
  subnet_id = aws_subnet.sub1.id
  route_table_id = aws_route_table.routeTable.id
}

resource "aws_route_table_association" "route_associatio_sub2" {
  subnet_id = aws_subnet.sub2.id
  route_table_id = aws_route_table.routeTable.id
}


# Secutity Group
resource "aws_security_group" "mysg" {
    name = "websg"
    vpc_id      = aws_vpc.myvpc.id

    tags = {
        Name = "mysg"
    }
}
resource "aws_vpc_security_group_ingress_rule" "mysg_ingress_http" {
  security_group_id = aws_security_group.mysg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "mysg_ingress_ssh" {
  security_group_id = aws_security_group.mysg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "mysg_egress" {
  security_group_id = aws_security_group.mysg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# S3 bucket
resource "aws_s3_bucket" "mys3bucketaadarsh261009543" {
    bucket = "my-tf-test-bucket"
}

resource "aws_s3_bucket_ownership_controls" "my_s3_owner" {
  bucket = aws_s3_bucket.mys3bucketaadarsh261009543.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "bucket_public" {
  bucket = aws_s3_bucket.mys3bucketaadarsh261009543.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "my_s3_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.my_s3_owner,
    aws_s3_bucket_public_access_block.bucket_public,
  ]

  bucket = aws_s3_bucket.mys3bucketaadarsh261009543.id
  acl    = "public-read"
}


# EC2 Instances
resource "aws_instance" "ec2_sub1" {
  ami = "ami-0ae8f15ae66fe8cda"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.mysg.id]
  subnet_id = aws_subnet.sub1.id
  user_data = file("${path.module}/data1.sh")
}

resource "aws_instance" "ec2_sub2" {
  ami = "ami-0ae8f15ae66fe8cda"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.mysg.id]
  subnet_id = aws_subnet.sub2.id
  user_data = file("${path.module}/data2.sh")
}

