#!/bin/bash

sudo yum update -y
sudo yum install -y docker
service docker start
sudo docker run hello-world
sudo docker run --name docker-nginx -p 80:80 nginx