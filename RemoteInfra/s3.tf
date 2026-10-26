resource "aws_s3_bucket" "remote_s3" {
  bucket = "remote-backend-s3-tws"
  force_destroy = true
  tags = {
    Name = "remote-s3-bucket"
  }
}