#!/bin/bash
# Script to create the directory and file structure for the CI/CD Project

echo "Creating core directories..."

# 1. Infrastructure Folders
mkdir -p infra/userdata

# 2. Application Folders
mkdir -p app/src/main/webapp

# 3. Pipeline Folders
mkdir -p jenkins
mkdir -p scripts

echo "Creating root files (README.md, .gitignore)..."

# 4. Root Files
touch .gitignore
touch README.md

echo "Creating Infrastructure files (.tf and .sh templates)..."

# 5. Infra Files
touch infra/variables.tf
touch infra/main.tf
touch infra/vpc.tf
touch infra/security_groups.tf
touch infra/iam.tf
touch infra/asg_launch_template.tf
touch infra/alb_asg.tf
touch infra/outputs.tf
touch infra/userdata/instance_user_data.sh.tpl
touch infra/userdata/jenkins_user_data.sh.tpl

echo "Creating Application files (pom.xml, Dockerfile, index.jsp)..."

# 6. App Files
touch app/pom.xml
touch app/Dockerfile
touch app/src/main/webapp/index.jsp

echo "Creating Pipeline and Script files..."

# 7. Pipeline and Scripts
touch jenkins/Jenkinsfile
touch scripts/trigger_ssm_update.sh

echo "--------------------------------------------------------"
echo "✅ Project structure successfully created!"
echo "Now you can copy the content into these empty files."
echo "--------------------------------------------------------"
