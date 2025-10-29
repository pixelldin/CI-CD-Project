variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "project" {
  type    = string
  default = "ci-cd-simple"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "allowed_ssh_cidr" {
  type    = string
  description = "Restrict SSH access (your IP/CIDR). Change before apply!"
  default = "0.0.0.0/0"
}

variable "instance_type" {
  type    = string
  default = "t3a.small"
}

variable "key_pair_name" {
  type    = string
  description = "EC2 key pair name (optional). Leave empty to skip."
  default = ""
}

# Docker image placeholder (not used for provisioning EC2 - used by pipeline)
variable "app_docker_image" {
  type = string
  default = "yourdockerhubuser/static-site:latest"
}
