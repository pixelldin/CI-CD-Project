output "git_public_ip" {
  value = aws_instance.git.public_ip
}

output "jenkins_public_ip" {
  value = aws_instance.jenkins.public_ip
}

output "docker_public_ip" {
  value = aws_instance.docker.public_ip
}
