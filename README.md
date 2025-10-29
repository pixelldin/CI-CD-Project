CI/CD Pipeline Project: Terraform, Jenkins, Docker, AWS (ALB/ASG)

This repository details a complete, production-grade CI/CD pipeline project. The infrastructure is defined entirely as code using Terraform, ensuring high availability and scalability via an Application Load Balancer (ALB) and Auto Scaling Group (ASG).

🚀 Interactive Pipeline Explorer

As requested, here is the live link to the interactive flow diagram that visually explains every stage and tool in this project.

(Replace the placeholder link above with your actual GitHub Pages URL after deployment.)

Project Architecture Overview

The project follows a robust, multi-stage, multi-tool approach:

Infrastructure Provisioning: Terraform creates a secure VPC and all networking components, including a dedicated Jenkins Server and the ALB/ASG for the application tier.

Continuous Integration (CI): Code is pushed to GitHub, triggering Jenkins. Jenkins uses Maven to build the Java web application (.jsp to .war).

Containerization: The built artifact is packaged into a Docker image.

Continuous Delivery (CD): Jenkins executes a deployment script (via SSH/SSM) that targets all instances in the ASG, pulling the new Docker image and running it, achieving zero-downtime deployment.

🛠️ Key Components & Tools

Component

Tool

Purpose

Scalability Feature

VPC

Terraform / AWS

Isolated, multi-AZ network foundation.

Multi-AZ Subnets

App Compute

Terraform / AWS ASG

Hosts the Dockerized Tomcat application.

Auto Scaling Group (ASG)

Load Balancing

Terraform / AWS ALB

Distributes traffic and handles health checks.

Application Load Balancer (ALB)

CI Orchestration

Jenkins

Automates the build, test, and containerization process.



Build Tool

Maven

Compiles the Java/JSP source code into a .war file.



Packaging

Docker

Ensures the application runs consistently across environments.



Getting Started

Prerequisites

AWS Account with configured credentials.

Terraform CLI installed locally.

An existing SSH Key Pair in your target AWS region.

1. Configure and Deploy Infrastructure

Navigate to the infra directory.

Initialize Terraform:

terraform init


Create terraform.tfvars: Copy terraform.tfvars.example and fill in your values, especially your existing key_name.

Review and Apply:

terraform plan
terraform apply


This will provision your entire AWS infrastructure (VPC, Subnets, Security Groups, ALB, ASG, Jenkins Server).

2. Post-Deployment Setup (Manual First Steps)

Access Jenkins: Use the jenkins_url output from Terraform (e.g., http://<Jenkins_IP>:8080).

Retrieve Password: SSH into the Jenkins server using the jenkins_ssh_ip and your private key, then run: sudo cat /var/lib/jenkins/secrets/initialAdminPassword

Configure Jenkins: Complete the setup wizard (install recommended plugins).

Configure GitHub Webhook: In your GitHub repo settings, add a webhook to your Jenkins URL (http://<Jenkins_IP>:8080/github-webhook/).

3. Setup Jenkins Pipeline

In Jenkins, create a new item (Pipeline) named webapp-cicd.

Under the Pipeline definition, choose Pipeline script from SCM.

SCM: Git

Repository URL: https://github.com/pixelldin/CI-CD-Project

Script Path: jenkins/Jenkinsfile

Once set up, a code push to the main branch will automatically execute the entire CI/CD pipeline!