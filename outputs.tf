output "ec2_public_ip" {
  # value = aws_instance.my-vm[*].public_ip
  value = [
    for instance in aws_instance.my-vm : instance.public_ip
  ]
}

output "ec2_private_ip" {
  # value = aws_instance.my-vm[*].private_ip
  value = [
    for instance in aws_instance.my-vm : instance.private_ip
  ]
}

output "ec2_public_dns" {
  # value = aws_instance.my-vm[*].public_dns
  value = [
    for instance in aws_instance.my-vm : instance.public_dns
  ]
}