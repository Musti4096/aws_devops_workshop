#!/bin/bash

yum update -y
yum install -y httpd
yum install -y wget
chkconfig httpd on
cd /var/www/html
wget https://raw.githubusercontent.com/awsdevopsteam/route-53/master/frankfurt/index.html
wget https://raw.githubusercontent.com/awsdevopsteam/route-53/master/frankfurt/frankfurt.jpg
service httpd start