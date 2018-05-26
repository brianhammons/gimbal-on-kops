#!/bin/bash -ex
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum install jenkins -y 
sudo yum install java-1.8.0-openjdk -y
sudo yum remove java-1.7.0-openjdk -y
sudo service jenkins start
sudo chkconfig jenkins on
export AdminPWD=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)
echo $AdminPWD