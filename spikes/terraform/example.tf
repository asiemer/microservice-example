provider "aws" {
  access_key = "AKIAISSBAMQWURCDRXCA"
  secret_key = "QQ7pj0POgsLPXkRSbdCOFrIOkNp/RTb3e779rOqA"
  region     = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-13be557e"
  instance_type = "t2.micro"
}