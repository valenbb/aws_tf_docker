provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_security_group" "docker" {
  name        = "docker-sg"
  description = "Security group for docker"
  vpc_id      = "${var.vpc_prod_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["74.109.185.9/32"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["74.109.185.9/32"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["74.109.185.9/32"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["74.109.185.9/32"]
  }

  egress {
   from_port = 0
   to_port = 0
   protocol = "-1"
   cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "docker-sg"
    owner = "alalla"
    env = "dev"
    app = "docker"
    Builder = "Terraform"
  }
}

resource "aws_instance" "docker" {
  ami           = "${var.aws_ami}"
  instance_type = "${var.instance_type}"

  tags {
    Name = "docker"
    owner = "alalla"
    env = "dev"
    app = "docker"
    Builder = "Terraform"
  }

  availability_zone = "${var.az_id}"
  subnet_id         = "${var.subnet_id}"
  key_name          = "${var.key_name}"
  vpc_security_group_ids = ["${aws_security_group.docker.id}"]
  associate_public_ip_address = true
  user_data       = "${file("docker.sh")}"
  
}