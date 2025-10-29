aws_region = "us-east-1"
project = "ci-cd-simple"
vpc_cidr = "10.0.0.0/16"
public_subnet_cidr = "10.0.1.0/24"
allowed_ssh_cidr = "103.82.211.251/32" # CHANGE THIS to your IP
instance_type = "t3a.small"
key_pair_name = "" # optional
app_docker_image = "yourdockerhubuser/static-site:latest"
