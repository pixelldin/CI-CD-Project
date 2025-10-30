# CI/CD Pipeline Project: Terraform, Jenkins, Docker, AWS (ALB/ASG)

<img width="1677" height="682" alt="image" src="https://github.com/user-attachments/assets/08002181-6d38-4831-aafa-c19d809c4cd4" />


This repository details a complete, production-grade CI/CD pipeline project. The infrastructure is defined entirely as code using Terraform, ensuring high availability and scalability via an **Application Load Balancer (ALB)** and **Auto Scaling Group (ASG)**.

## 🚀 Interactive Pipeline Explorer visual link : 

As requested, here is the live link to the interactive flow diagram that visually explains every stage and tool in this project.

https://pixelldin.github.io/Interactive-page/

## Project Architecture Overview

The project follows a robust, multi-stage, multi-tool approach:

1. Infrastructure Provisioning: Terraform creates a secure VPC and all networking components, including a dedicated **Jenkins Server** and the **ALB/ASG** for the application tier.
2. Continuous Integration (CI): Code is pushed to GitHub, triggering **Jenkins**. Jenkins uses Maven to build the Java web application (`.jsp` to `.war`).
3. Containerization: The built artifact is packaged into a Docker image.
4. Continuous Delivery (CD): Jenkins executes a deployment script (via SSH/SSM) that targets all instances in the **ASG**, pulling the new Docker image and running it, achieving zero-downtime deployment.

### 🛠️ Key Components & Tools

| **Component** | **Tool** | **Purpose** | **Scalability Feature** |
| --- | --- | --- | --- |
| **VPC** | Terraform / AWS | Isolated, multi-AZ network foundation. | Multi-AZ Subnets |
| **App Compute** | Terraform / AWS ASG | Hosts the Dockerized Tomcat application. | Auto Scaling Group (ASG) |
| **Load Balancing** | Terraform / AWS ALB | Distributes traffic and handles health checks. | Application Load Balancer (ALB) |
| **CI Orchestration** | Jenkins | Automates the build, test, and containerization process. |  |
| **Build Tool** | Maven | Compiles the Java/JSP source code into a `.war` file. |  |
| **Packaging** | Docker | Ensures the application runs consistently across environments. |  |

## Getting Started

### Prerequisites

1. **AWS Account** with configured credentials.
2. **Terraform CLI** installed locally.
3. An existing **SSH Key Pair** in your target AWS region.

### 1. Configure and Deploy Infrastructure

Navigate to the `infra` directory.

1. **Initialize Terraform:**
    
    ```
    terraform init
    
    ```
    
2. **Create `terraform.tfvars`:** Copy `terraform.tfvars.example` and fill in your values, especially your existing `key_name`.
3. **Review and Apply:**
    
    ```
    terraform plan
    terraform apply
    
    ```
    
    This will provision your entire AWS infrastructure (VPC, Subnets, Security Groups, ALB, ASG, Jenkins Server).
    

### 2. Post-Deployment Setup (Manual First Steps)

1. **Access Jenkins:** Use the `jenkins_url` output from Terraform (e.g., `http://<Jenkins_IP>:8080`).
2. **Retrieve Password:** SSH into the Jenkins server using the `jenkins_ssh_ip` and your private key, then run: `sudo cat /var/lib/jenkins/secrets/initialAdminPassword`
3. **Configure Jenkins:** Complete the setup wizard (install recommended plugins).
4. **Configure GitHub Webhook:** In your GitHub repo settings, add a webhook to your Jenkins URL (`http://<Jenkins_IP>:8080/github-webhook/`).

### 3. Setup Jenkins Pipeline

1. In Jenkins, create a new item (Pipeline) named `webapp-cicd`.
2. Under the Pipeline definition, choose **Pipeline script from SCM**.
3. **SCM:** Git
4. **Repository URL:** `https://github.com/pixelldin/CI-CD-Project`
5. **Script Path:** `jenkins/Jenkinsfile`

Once set up, a code push to the `main` branch will automatically execute the entire CI/CD pipeline!
