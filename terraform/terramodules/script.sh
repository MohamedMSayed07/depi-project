#!/bin/bash
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
    https://pkg.jenkins.io/debian/jenkins.io-2023.key

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
    https://pkg.jenkins.io/debian binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update -y
sudo apt-get install -y fontconfig openjdk-17-jre
sudo apt-get install -y jenkins
sudo snap install terraform --classic
sudo snap install aws-cli --classic
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh