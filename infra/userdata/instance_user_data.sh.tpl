#!/bin/bash
set -e
# Simple bootstrap for Git server (git over SSH)
yum update -y
amazon-linux-extras install -y git
# create git user
id -u git >/dev/null 2>&1 || useradd -m -s /bin/bash git
mkdir -p /home/git/repos
chown -R git:git /home/git/repos
# optional: install and configure sshd settings for git (default OpenSSH suffices)
# you can clone via: git@<git_public_ip>:/home/git/repos/<repo>.git
# create a sample bare repo
sudo -u git bash -c "cd /home/git/repos && git init --bare sample-site.git"
# keep instance reachable via SSM; logs
echo "Git server bootstrap completed" > /var/log/git_bootstrap.log
