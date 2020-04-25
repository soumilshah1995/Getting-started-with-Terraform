
# Define your AWS configuration
provider "aws" {
  profile = "default"
  region = "us-east-1"
}

# Define your S3 AWS Resource
resource  "aws_s3_bucket" "tf_course" {
  bucket = "soumilshah1995001"
  acl    = "private"
}

# Default VPC
resource "aws_default_vpc" "default" {

}

# Security Group
resource "aws_security_group" "prod_web" {
  # if you dont give it will give a random name better to give something
  name        = "prod_web"
  description = "Allow standard Http and Https Port inboud  and everything outbound"

  ingress {
    from_port = 80        # Outbound Traffic
    protocol  = "tcp"     # protocol we will use is tcp
    to_port   = 80        # outbound port is also 80

    # if you say "0.0.0.0/0" mean allow everything
    cidr_blocks = [
      "67.84.49.187/32",
    ]
  }

  # ingress mean inbound traffic we are configuring for https now
  ingress {
    from_port = 443        # Outbound Traffic
    protocol  = "tcp"     # protocol we will use is tcp
    to_port   = 443        # outbound port is also 80

    # if you say "0.0.0.0/0" mean allow everything
    cidr_blocks = [
      "67.84.49.187/32",
    ]
  }

  # outBound traffic -1 mean allow all protocol
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0

    cidr_blocks = [
      "67.84.49.187/32",
    ]

  }

  # Best Recommend practise to put tags
  tags =  {
    "Terraform" : "true"
  }
}

resource "aws_instance" "prod_web" {
  ami = "ami-03c8adc67e56c7f1d"
  instance_type = "t2.nano"

  vpc_security_group_ids = [
  aws_security_group.prod_web
  ]

  tags =  {
    "Terraform" : "true"
  }
}