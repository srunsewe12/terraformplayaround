provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "walkthrough" {
    ami           = "ami-0264263f58566cf19"
    instance_type = "t2.micro"

    tags = {
        Name = "terraform-example"
    }
}