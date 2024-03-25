output "get_ip" {
    description = "The IP address of the EC2 instance"
    value = aws_instance.checking_instance.public_ip
}


output "get_public_dns" {
    description = "The public DNS name of the EC2 instance"
    value = aws_instance.checking_instance.public_dns
}