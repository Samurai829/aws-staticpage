#!/bin/bash

sudo yum update -y
sudo yum install -y docker
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo docker pull samurai829/staticpages:1.0
sudo docker run -dp 8080:8080 samurai829/staticpages:1.0