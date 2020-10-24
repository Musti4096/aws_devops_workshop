# Hands-on : Route 53 

Purpose of the this hands-on training is to creating a DNS record sets and implement Route 53 routing policies. 


## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- create record sets

- manage the domain name routing

- implement routing policies in different use case

## Outline

- Part 1 - Prep.

- Part 2 - Creating record sets (A, CNAME, Alias)

- Part 3 - Creating a fail-over routing policies

- Part 4 - Creating a geolocation routing policies

- Part 5 - Creating a weighted routing policies


## Part 1 - Part 1 - Prep.

# STEP 1: Create Sec.Group:
```bash
   Route 53 Sec: In bound : "SSH 22, HTTP 80  > anywhere(0:/00000)"
```
# STEP 2: Create Instances:

- We'll totally create "4" instances.
   
 1. Create EC2 that is installed httpd user data in default VPC named "N.virginia_1"
```bash
Region: "N.Virginia"
VPC: Default VPC
Subnet: PublicA
Sec Group: "Route 53 Sec"

user data: 

#!/bin/bash
yum update -y
yum install -y httpd
yum install -y wget
cd /var/www/html
wget https://raw.githubusercontent.com/awsdevopsteam/route-53/master/N.virginia_1/index.html
wget https://raw.githubusercontent.com/awsdevopsteam/route-53/master/N.virginia_1/N.virginia_1.jpg
systemctl start httpd
systemctl enable httpd



```

2. Create EC2 that is installed httpd user data in default VPC "N.virginia_2"
```bash
Region: "N.Virginia"
VPC: Default VPC
Subnet: PublicA
Sec Group: "Route 53 Sec"

user data:

#!/bin/bash
yum update -y
yum install -y httpd
yum install -y wget
cd /var/www/html
wget https://raw.githubusercontent.com/awsdevopsteam/route-53/master/N.virginia_2/index.html
wget https://raw.githubusercontent.com/awsdevopsteam/route-53/master/N.virginia_2/N.Virginiatwo.jpg
systemctl start httpd
systemctl enable httpd



```

3. Create EC2 that is installed httpd user data in tokyo region default VPC "Geo-Japon"
```bash
Region: "N.Virginia"
VPC: Default VPC
Subnet: PublicA
Sec Group: "Route 53 Sec"

   "user data:"

#!/bin/bash
yum update -y
yum install -y httpd
yum install -y wget
cd /var/www/html
wget https://raw.githubusercontent.com/awsdevopsteam/route-53/master/geo-japon/index.html
wget https://raw.githubusercontent.com/awsdevopsteam/route-53/master/geo-japon/Tsubasa.jpg
systemctl start httpd
systemctl enable httpd

```


4. Create EC2 that is installed httpd user data in "Frankfurt" "Geo-Frankfurt"
 ```bash 
Region: "N.Virginia"
VPC: Default VPC
Subnet: PublicA
Sec Group: "Route 53 Sec"

user data:

#!/bin/bash
yum update -y
yum install -y httpd
yum install -y wget
cd /var/www/html
wget https://raw.githubusercontent.com/awsdevopsteam/route-53/master/frankfurt/index.html
wget https://raw.githubusercontent.com/awsdevopsteam/route-53/master/frankfurt/frankfurt.jpg
systemctl start httpd
systemctl enable httpd


```
# STEP 3: Create 2 Static WebSite Hosting :

 1. Create Static WebSite Hosting-1/ "www.[your sub-donamin name].net"
 
  - Go to S3 service and create a bucket with sub-domain name: "www.[your sub-donamin name].net"
  - Public Access "Enabled"
  - Upload Files named "index.html" and "sorry.jpg" in "s3.bucket.www" folder
  - Permissions>>> Bucket Policy >>> Paste bucket Policy
```bash
{
    "Version": "2012-10-17", 
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::don't forget to change me/*"
        }
    ]
}


```
  - Preporties>>> Set Static Web Site >>> Enable >>> Index document : index.html 
 
 2. Create Static WebSite Hosting-2/ "info.[your sub-donamin name].net"

  - Create a bucket with "sub-domain name" "info.[your sub-donamin name].net"
  - Public Access "Enabled"
  - Upload Files named "index.html" and "ryu.jpg" in "s3.bucket.info" folder
  - Permission>>> Bucket Policy >>> Paste bucket Policy
```bash
{
    "Version": "2012-10-17", 
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::don't forget to change me/*"
        }
    ]
}
```

  - Preporties>>> Set Static Web Site >>> Enable >>> Index document : index.html 
 

## Part 2 - Creating Record Sets (A, CNAME, Alias)

# STEP 1 : Create A Record with "www" subdomain:

- Go to Route 53 service

- Click hosted zones on the left hand menu

- click your Domain name's public hosted zone

- click "create record"

- select "simple routing" ---> Next

- click "Define simple record"

- Create A record with N. Virginia_1
```bash
Record Name:"www"
Value/Route traffic to: 
  - select "IP address or another value depending the record type" option 
      - enter IP of the "N.Virginia_1" EC2
Record Type : A
Type: "A – IPv4 address"
Alias:"No"
TTL:"1m"
```
- Select newly created record's flag and hit the "create record" tab seen bottom

# STEP 2 : Create another "A record" with N. Virginia_1 with "info" subdomain

- Go to Route 53 service

- Click hosted zones on the left hand menu

- click your Domain name's public hosted zone

- click "create record"

- select "simple routing" ---> Next

- click "Define simple record"

- Create A record with N. Virginia_1
```bash
Record Name:"info"
Value/Route traffic to: 
  - select "IP address or another value depending the record type" option 
      - enter IP of the "N.Virginia_1" EC2
Record Type : A
TTL:"1m"
```
- Select newly created record's flag and hit the "create record" 
tab seen bottom

- After show "info.[your DNS name].net" on the browser, "Delete" this record 


# STEP 3: Add another IP (N. Virginia_2)  to the existing "A record" 

- select "www.[your DNS name].net" A-record ---> Edit
```bash
Name:"www"
Value/Route traffic to:
    "IP of N.Virginia_1" ,and 
    "IP of N.Virginia_2"
```

- Check from local terminal
nslookup www.[your DNS name].net an show two IP address 

# STEP 4 : CNAME Record:

- Add CNAME record for "Domain Name" 

- click your Domain name's public hosted zone

- click "create record"

- select "simple routing" ---> Next

- click "Define simple record"

```bash
Record Name:"showcname"
Value/Route traffic to: 
  - "IP address or another value depending on the record type"
    - enter "www.[your DNS name].net"
Record Type : "CNAME"-Routes to another domain and some AWS resources
TTL:"1m"
```
- hit the define simple record

- Select newly created record's flag and hit the "create record" 
tab seen bottom

- After show "showcname.[your DNS name].net" on the browser. It will reflects the "www.[your DNS name].net". After that "Delete"  this record 

# STEP 5 : Alias Record:

- Add CNAME record for "Domain Name" 

- click your Domain name's public hosted zone

- click "create record"

- select "simple routing" ---> Next

- click "Define simple record"

```bash
Record Name:"info"
Value/Route traffic to: 
    - Alias to S3 website endpoint
    - US East (N.Virginia) [us-east-1]
    - choose your S3 bucket named "info.[your DNS name].net"
Record Type : A
```
- hit the define simple record

- Select newly created record's flag and hit the "create record" 
tab seen bottom


- go to the target domain name "info.[your DNS name].net" on browser

- show the content of web page. It is the same as  S3 static web hosting page.

   
### Part 3 - Creating a fail-over routing policies

# STEP 1 : Create health check for "N. virgnia_1" instance

- Go to left hand pane and click the Health check menu 

- Click Health check button

- Configure Health Check
```bash 
1. Name: firsthealthcheck

What to monitor     : Endpoint

Specify endpoint by : IP adress

Protocol            : HTTP

IP address          : N.Virginia_1 IP adress

Hostname:           : -

Port                : 80

Path                : leave it as /

Advange Configuration 

Request Interval    :  Standart (30seconds)

Failure Threshold   : 3

Explain Response Time:

Failure = Time Interval * Threshold. If its a standard 30 seconds check then three checks is actually equal to 90 seconds. So be careful of how these two different settings interact each other.

String Matching     : No 

Latency Graphs:     : Keep it as is

Invert Health Check Status: Keep it as is

Disable Health Check:
Explain: If you disable a health check, Route 53 considers the status of the health check to always be healthy. If you configured DNS failover, Route 53 continues to route traffic to the corresponding resources. If you want to stop routing traffic to a resource, change the value of Invert health check status.

Health Checker Regions: Keep it as default

click Next

Get Notifcation   : None

click create and show that the status is unhealthy aproximitely after 90 seconds the instance healthcheck will turned into the "healthy" from "unhealthy"
```
# Step 2: Create A record for  "N. virgnia_1" instance IP - Primary record

- Got to the hosted zone and select the public hosted zone of our domain name

- Clear all teh record sets except NS and SOA

- Click create record

- select "Failover" as a routing policy

- click next

```bash
Record Name :"www"
Record Type : A
TTL:"60"
```

- Failover records to add to [you DNS name] 

- Define Failover record
```bash
Value/Route traffic to : 
  - "Ip adress or another value depending on the record type"
    - enter IP IP address of N.Virginia_1 
Failover record type    : Primary
Health check            : firsthealthcheck
Record ID               : Failover Scenario-primary
```
- click defined Failover record button

- select created failover record flag and push the create records button

# Step 3: Create A record for S3 website endpoint - Secondary record

- Click create record

- select "Failover" as a routing policy

- click next

```bash
Record Name :"www"
Record Type : A
TTL:"60"
```

- Failover records to add to [you DNS name] 

- Define Failover record
```bash
Value/Route traffic to : 
  - "Alias to S3 website endpoint"
  - N.Virginia(us-east-1)
  - Choose your S3 bucket named "www.[your sub-donamin name].net"
Failover record type    : Secondary
Health check            : keep it as is
Record ID               : Failover Scenario-secondary
```
- click define Failover record button

- select created failover record flag and push the create records button

- Go to browser and show the web page with N.Virginia_1 instance content 

- stop the N.Virginia_1 instance

- check the healtcheck status and wait until it appears as unhealthy

- go to the browser and show the web site content turned into S3 bucket content with the help of the failover record



## Part 4 - Creating a Geolocation routing policies

# STEP 1 :Create geolocation record for Japan

- Click create record

- select "Geolocation" as a routing policy

- click next

```bash
Record Name :"geo"
Record Type : A
TTL:"60"
```

- Define geolocation record
```bash
Value/Route traffic to : 
  - "Ip adress or another value depending on the record type"
    - "IP of Geo-Japon Instace"
Location               :
  - Countries Japan
Health check            : Keep it as is
Record ID               : Geolocation Scenario-Japan
```
- click "define geolocation record" button

- select created Geolocation record flag and push the "create records" button


# STEP 2 : Create geolocation record for Europe

- Click create record

- select "Geolocation" as a routing policy

- click next

```bash
Record Name :"geo"
Record Type : A
TTL:"60"
```

- Define geolocation record

```bash
Value/Route traffic to : 
  - "Ip adress or another value depending on the record type"
    - "IP of Geo-Frankfurt Instance"
Location               :
  - Countinent : Europe
Health check            : Keep it as is
Record ID               : Geolocation Scenario-Europe
```
- click "define geolocation record" button

- select created Geolocation record flag and push the "create records" 
button


# STEP 3 : Create geolocation record for others

- Click create record

- select "Geolocation" as a routing policy

- click next

```bash
Record Name :"geo"
Record Type : A
TTL:"60"
```

- Define geolocation record

```bash
Value/Route traffic to : 
  - "Ip adress or another value depending on the record type"
    - "IP of Geo-Frankfurt Instance"
Location               : Select Default option
Health check           : Keep it as is
Record ID              : Geolocation Scenario-Others
```
- click "define geolocation record" button

- select created Geolocation record flag and push the "create records" 
button

- change the IP of your computer via VPN and see the Japon page.

- change the IP of your computer via VPN and see the Europe page.

- Send the dns to students try for US and show them different web page based on location.



### Part 5 - Creating a weighted routing policies

# STEP 1 : : Create 40 percent weighted record 

- Click create record

- select "weighted" as a routing policy

- click next

```bash
Record Name :"weight"
Record Type : A
TTL:"60"
```

- Define weighted record

```bash
Value/Route traffic to : 
  - "Ip adress or another value depending on the record type"
    - "IP of N.Virginia_1 Instance"
Weight                 : 40
Health check           : Keep it as is
Record ID              : weighted Scenario-40
```
- click "define weighted record" button

- select created weighted record flag and push the "create records" 
button

# STEP 2 : Create 60 percent weighted record

- Click create record

- select "weighted" as a routing policy

- click next

```bash
Record Name :"weight"
Record Type : A
TTL:"60"
```

- Define weighted record

```bash
Value/Route traffic to : 
  - "Ip adress or another value depending on the record type"
    - "IP of N.Virginia_2 Instance"
Weight                 : 60
Health check           : Keep it as is
Record ID              : weighted Scenario-60
```
- click "define weighted record" button

- select created weighted record flag and push the "create records" 
button

- Go to the browser and paste the "weight.[your Domain name].net" address and refresh the page, show students the content changes based on weighted scenario.

 -Also, send your DNS name from slack to ensure weighted policy work properly.(Although you refresh the page, sometimes the content doesn't changes because of the internet provider.)

### Part 6 - Creating Local Hosted Web

# Step-1. Create EC2 that is installed httpd user data in "N.Virginia Region" as "Local"

Region: "N.virginia"
VPC: clarus-vpc-a
Subnet: PublicA
Sec Group: "SSH 22, HTTP 80  > anywhere(0:/00000)"

"user data:"

#!/bin/bash
yum update -y
yum install -y httpd
yum install -y wget
cd /var/www/html
wget https://raw.githubusercontent.com/awsdevopsteam/route-53/master/N.virginia_2/index.html
wget https://raw.githubusercontent.com/awsdevopsteam/route-53/master/N.virginia_2/N.Virginiatwo.jpg
systemctl start httpd
systemctl enable httpd


# Step-2 Create "Windows" EC2
   Region: "N.virginia"
   "AMI": Microsoft Windows Server 2019 Base - "ami-05bb2dae0b1de90b3"
   VPC: clarusvpc-a
   Subnet: PublicA
   Sec Group: "RDP >>>>>anywhere"  
   user data:"-"

# Step-3 Create Private Hosted Zone

# Step-4 Create A record in "Private Hosted" Zone for "Local" EC2 IP

# Step-5 Create A record in Public Hosted Zone for N:Virginia_1 IP

- open windows instance and connect to browser. paste wwww.domainname.com

- open your browser show the wwww.domainname.com. Show contents are different 

