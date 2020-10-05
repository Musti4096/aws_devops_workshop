# create security group with http and ssh rules
# create launch template for Amazon Linux 2 with user data as below and with a-b-c AZs
########################
#!/bin/bash
#update os
yum update -y
#install epel
amazon-linux-extras install epel -y
#install stress tool
yum install -y stress
#install apache server
yum install -y httpd
# get private ip address of ec2 instance using instance metadata
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"` \
&& PRIVATE_IP=`curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-ipv4`
# get public ip address of ec2 instance using instance metadata
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"` \
&& PUBLIC_IP=`curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/public-ipv4` 
# get date and time of server
DATE_TIME=`date`
# set all permissions 
chmod -R 777 /var/www/html
# create a custom index.html file
echo "<html>
<head>
    <title> ELB with Call</title>
</head>
<body>
    <h1>Testing Application Load Balancer with Call</h1>
    <p>This web server is launched from launch template by YOUR_NAME</p>
    <p>This instance is created at <b>$DATE_TIME</b></p>
    <p>Private IP address of this instance is <b>$PRIVATE_IP</b></p>
    <p>Public IP address of this instance is <b>$PUBLIC_IP</b></p>
</body>
</html>" > /var/www/html/index.html
# start apache server
systemctl start httpd
systemctl enable httpd
#################################

# create loadbalancer together with target group and do not add any instance to the target group. Configure them to work with with a-b-c AZs, and change target group healthy threshold to 2.
# observe the response of "503 Service Temporarily Unavailable" from load balancer
# create auto scaling group with a-b-c AZs, using launch template 
    # instance numbers, initial 2, min 2, max 4
    # receive traffic from target group
    # Health check type EC2, health check grace period 30s
    # setup simple policy for both decrease and increase group size
    # simple policy for increasing the instance number, 
        # select cpu usage >= 50% for last 1 min, 
        # setup an alarm and sns notification,
        # add 1 instance
        # wait 60s
    # simple policy for decreasing the instance number, 
        # select cpu usage <= 20% for last 1 min, 
        # setup an alarm and sns notification,
        # remove 1 instance
        # wait 60s
# check the email and confirm subscription
# edit auto scaling group configuration and increase maximum number of instances to 4
# observe the alb is working as expected with round robin algorithm
# change the health check configuration in target group, success codes = 301 to make alb fail the health checks
# observe health status within target group, (all health statuses should be unhealthy), but still forwarding request to the all instances
# observe health status within asg/instances, (health statuses should be healthy), so no new instance will be launched
# change the health check configuration in target group, success codes = 200 to make them healthy again
# connect the one of instances with ssh and stop the apache server
sudo systemctl stop httpd
sudo systemctl status httpd 
# observe health status within target group, (health status of the stopped server should be unhealthy), and forwarding request to the stopped server instance
# observe health status within asg/instances, (health statuses should be healthy), so no new instance will be launched
# connect the same instance with ssh, restart the apache server and make sure it's running again.
sudo systemctl restart httpd 
sudo systemctl status httpd
# observe the alb is working as expected again
# terminate one of the ec2 instances from ec2 dashboard
# observe the instances health statuses within both target group and asg/instance, in asg instance health status should fail and in target group instance should be gone from the list. As a result, new instance should be launched by asg.
# stressed currently running instances with commands below 
stress --cpu 2 --timeout 300 &
watch uptime
# observe the cloud-watch for alarm state
# check email for sns notifications
# monitor effect of our stress command which should cause asg to add extra instances
# change health check type to EC2 within asg
# connect the one of instances with ssh and stop the apache server
sudo systemctl stop httpd
sudo systemctl status httpd 
# observe health status within target group, (health status of the stopped server should be unhealthy), and forwarding request to the stopped server instance
# observe health status within asg/instances, (health statuses should be unhealthy), so new instance shoulb be launched for replacement


# change launch template with new version (with blog services) by only modifying user data part as shown below
######################################
# create a folder for blog
mkdir -p /var/www/html/blog
# create a custom index.html file
echo "<html>
<head>
    <title> ELB with Call</title>
</head>
<body>
    <h1>Testing Application Load Balancer with Blog Services</h1>
    <p>This web server is launched from launch template by Callahan</p>
    <p>This instance is created at <b>$DATE_TIME</b></p>
    <p>Private IP address of this instance is <b>$PRIVATE_IP</b></p>
    <p>Public IP address of this instance is <b>$PUBLIC_IP</b></p>
</body>
</html>" > /var/www/html/blog/index.html
######################################
# launch two instances using the new launch template
# check each instance using their public ips if the new blog service web servers are working
# create a target group for blog web servers, configure health check for "/blog/" path, and add two instances to the target group  
# insert a new rule to the existing listener within alb, and configure a rule to forward request the new target group (blog-web-servers-tg), when  path is equal to "/blog/*"
# observe that alb is forwarding requests to two different target group based on the path