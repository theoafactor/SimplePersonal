terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~>5.1"
        }
    }
}

// after the initial setup, ...
// configure the provider 

provider "aws" {
    region = "us-east-1"
} 

// create a keypair 
resource "tls_private_key" "testerman" {
    algorithm = "RSA"
    rsa_bits = "4096"
}

resource "aws_key_pair" "testerman_key_pair" {
    key_name = "testermankey6.pem"
    public_key = tls_private_key.testerman.public_key_openssh

}

//save the key locally 
resource "local_file" "stored_private_key" {
    content = tls_private_key.testerman.private_key_pem
    filename = aws_key_pair.testerman_key_pair.key_name

}

// create a security group
resource "aws_security_group" "checking_instance_sg" {
    name = "new_instance_sec_group_6"
    description = "Created security group with Terraform"
    vpc_id = "vpc-05eea395b4623bebc"
        
    ingress {
        description = "Ingress for allowing traffic into the instance"
        protocol = "TCP"
        from_port = 22
        to_port = 22
        cidr_blocks = ["0.0.0.0/0"]
    }

     ingress {
        description = "Ingress for allowing traffic for HTTP"
        protocol = "TCP"
        from_port = 80
        to_port = 80
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        description = "Egress for the instances created with Terraform"
        from_port = "0"
        to_port = "0"
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "A simple security group for the instances"
    }
}


// create an ec2 instance 
resource "aws_instance" "checking_instance" {
    ami = "ami-053b0d53c279acc90"
    instance_type = "t2.micro"
    subnet_id = "subnet-07677ad957fa848a4"
    key_name = aws_key_pair.testerman_key_pair.key_name
    associate_public_ip_address = true
    vpc_security_group_ids = [aws_security_group.checking_instance_sg.id]
    # user_data = file("_devops/setup.sh")
    tags = {
        Name = "first instance"
    }

    connection {
        type     = "ssh"
        user     = "ubuntu"
        private_key = file(aws_key_pair.testerman_key_pair.key_name)
        host     = self.public_ip
    }

    provisioner "remote-exec" {
       script = "_setup.sh"
       when = create
    }

}

