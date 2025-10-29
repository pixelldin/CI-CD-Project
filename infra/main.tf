# Networking: VPC, single public subnet
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  tags = { Name = "${var.project}-vpc" }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.this.id
  tags   = { Name = "${var.project}-igw" }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  tags = { Name = "${var.project}-public-subnet" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = { Name = "${var.project}-public-rt" }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
# IAM Role & Instance Profile (SSM)
data "aws_iam_policy_document" "ec2_assume" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "instance_role" {
  name               = "${var.project}-instance-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume.json
  tags = { Name = "${var.project}-instance-role" }
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.project}-instance-profile"
  role = aws_iam_role.instance_role.name
}

# Security Groups
# Allow HTTP from anywhere (for static site)
resource "aws_security_group" "http_sg" {
  name        = "${var.project}-http-sg"
  description = "Allow HTTP"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project}-http-sg" }
}

# Allow SSH only from allowed_ssh_cidr
resource "aws_security_group" "ssh_sg" {
  name        = "${var.project}-ssh-sg"
  description = "SSH access"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project}-ssh-sg" }
}

# EC2 Instances: Git, Jenkins, Docker
# Use templatefile() to render user_data

locals {
  common_userdata_vars = {
    project = var.project
  }
}

# Git server instance
resource "aws_instance" "git" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  associate_public_ip_address = true
  key_name               = length(var.key_pair_name) > 0 ? var.key_pair_name : null
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name
  vpc_security_group_ids = [aws_security_group.ssh_sg.id]

  user_data = templatefile("${path.module}/userdata/git_user_data.sh.tpl", {
    project = var.project
  })

  tags = {
    Name    = "${var.project}-git"
    Project = var.project
    Role    = "git"
  }
}

# Jenkins server instance
resource "aws_instance" "jenkins" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  associate_public_ip_address = true
  key_name               = length(var.key_pair_name) > 0 ? var.key_pair_name : null
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name
  vpc_security_group_ids = [aws_security_group.ssh_sg.id, aws_security_group.http_sg.id]

  user_data = templatefile("${path.module}/userdata/jenkins_user_data.sh.tpl", {
    project = var.project
  })

  tags = {
    Name    = "${var.project}-jenkins"
    Project = var.project
    Role    = "jenkins"
  }
}

# Docker server instance (will build images and optionally push to Docker Hub)
resource "aws_instance" "docker" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  associate_public_ip_address = true
  key_name               = length(var.key_pair_name) > 0 ? var.key_pair_name : null
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name
  vpc_security_group_ids = [aws_security_group.ssh_sg.id, aws_security_group.http_sg.id]

  user_data = templatefile("${path.module}/userdata/docker_user_data.sh.tpl", {
    project = var.project
  })

  tags = {
    Name    = "${var.project}-docker"
    Project = var.project
    Role    = "docker"
  }
}

########################################
# Data: AMI
########################################
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

########################################
# Outputs
########################################
output "git_public_ip" {
  value = aws_instance.git.public_ip
  description = "Public IP of Git server (use for SSH/git)"
}

output "jenkins_public_ip" {
  value = aws_instance.jenkins.public_ip
  description = "Public IP of Jenkins (default port 8080 after install)"
}

output "docker_public_ip" {
  value = aws_instance.docker.public_ip
  description = "Public IP of Docker server"
}
