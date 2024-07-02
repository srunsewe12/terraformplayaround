provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "walkthrough" {
    ami                    = "ami-0264263f58566cf19"
    instance_type          = "t2.micro"
    vpc_security_group_ids = [aws_security_group.terraform-example-instance.id]

    user_data = <<-EOF
                #!/bin/bash
                sudo yum update -y
                echo "Cloud Baddie" > index.html
                nohup python3 -m http.server 8080 &
                EOF
    user_data_replace_on_change = true

    tags = {
        Name = "terraform-example"
    }
}

resource "aws_security_group" "terraform-example-instance" {
    name = "terraform-example-instance"
    
    ingress {
        description = "SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "HTTP"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 8080
        to_port     = 8080
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