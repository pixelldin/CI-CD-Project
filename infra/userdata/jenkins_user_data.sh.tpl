#!/bin/bash
set -e
# Jenkins bootstrap on Amazon Linux 2
yum update -y
# install java
amazon-linux-extras install -y java-openjdk11
# install Jenkins (official)
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key || true
yum install -y jenkins
# start and enable
systemctl enable jenkins
systemctl start jenkins
# install docker client if you plan to use docker remote build from jenkins
yum install -y docker
systemctl enable docker
systemctl start docker
usermod -a -G docker jenkins || true
# create a place for workspace and initial files
mkdir -p /var/lib/jenkins_init
echo "Jenkins bootstrap complete" > /var/log/jenkins_bootstrap.log
