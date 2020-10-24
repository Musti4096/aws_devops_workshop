#!/bin/bash

yum update -y
yum install -y httpd
yum install -y wget
chkconfig httpd on
cd /var/www/html
wget https://raw.githubusercontent.com/awsdevopsteam/route-53/master/N.virginia_2/index.html
wget https://raw.githubusercontent.com/awsdevopsteam/route-53/master/N.virginia_2/N.Virginiatwo.jpg
service httpd start