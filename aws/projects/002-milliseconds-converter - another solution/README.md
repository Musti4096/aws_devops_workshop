# Project-002 : Milliseconds Converter Application (Python Flask) deployed on AWS Application Load Balancer with Auto Scaling Group using AWS Cloudformation

## Description

The Milliseconds Converter Application aims to convert the given time in milliseconds into hours, minutes, and seconds. The application is to be coded in Python and deployed as a web application with Flask on AWS Application Load Balancer with Auto Scaling Group of Elastic Compute Cloud (EC2) Instances using AWS Cloudformation Service.

## Problem Statement

![Project_002](Project_002_.png)

- Your company has recently started on a project that aims to be one of the most used unit converters and formulas website. After your team have deployed first converter app successfully, your company decided to go with The Milliseconds Converter Application which is the second the project. So you and your colleagues have started to work on the project.

- As a first step of the project, you need to write program that converts the given milliseconds into hours, minutes, and seconds. The program should convert only from milliseconds to hours/minutes/seconds, not vice versa and during the conversion following notes should be taken into consideration.

  - If the calculated time of hours is 0, it should not be shown in the output.

  - If the calculated time of minutes is 0, it should not be shown in the output.

  - If the calculated time of seconds is 0, it should not be shown in the output.

  - If the milliseconds is greater than 1000, remainder milliseconds should not be shown in the output.

  - If milliseconds given is less than 1000, only milliseconds should be shown in the output.

  - Output should always be string in the format shown in the examples.

- Example for user inputs and respective outputs

```text
Input             Output
(milliseconds)    (Calculated Time)
--------------    -----------------
555               just 555 millisecond/s
2001              2 second/s
60011             1 minute/s
122011            2 minute/s 2 second/s
3661011           1 hour/s 1 minute/s 1 second/s
7200011           2 hour/s
7322011           2 hour/s 2 minute/s 2 second/s
```

- As a second step, after you finish the coding, you are requested to deploy your web application using Python's Flask framework.

- You need to transform your program into web application using the `index.html` and `result.html` within the `templates` folder. Note the followings for your web application.
   
   - User should face first with `index.html` when web app started.

   - User input should be taken via `index.html` using HTTP `POST` method
   
   - User input can be either integer or string, thus the input should be checked for the followings,

      - The input should be a decimal number greater than zero.
      
      - If the input is less then 1, user should be warned with `Not Valid! Please enter a number greater than zero` using the `index.html` with template formatting.

      - If the input is string and can not be converted to decimal number, user should be warned with `Not Valid! Please enter a number greater than zero` using the `index.html` with template formatting.

   - Conversion result should be displayed using the `result.html` with template formatting.

   - The Web Application should be accessible via web browser from anywhere.

- Lastly, after transforming your code into web application, you are requested to push your program to the project repository on the Github and deploy your solution in the development environment on AWS Application Load Balancer using AWS Cloudformation Service to showcase your project. In the development environment, you can configure your Cloudformation template using the followings,

   - The application stack should be created with new AWS resources. 

   - Template should create Application Load Balancer with Auto Scaling Group of Amazon Linux 2 EC2 Instances within default VPC.
   
   - Application Load Balancer should be placed within a security group which allows HTTP (80) connections from anywhere.

   - EC2 instances should be placed within a different security group which allows HTTP (80) connections only from the security group of Application Load Balancer.

   - The Auto Scaling Group should use a Launch Template in order to launch instances needed and should be configured to;

      - use all Availability Zones.

      - set desired capacity of instances to `2`

      - set minimum size of instances to `1`

      - set maximum size of instances to `3`

      - set health check grace period to `90 seconds`

      - set health check type to `ELB`
      
   - The Launch Template should be configured to;
   
      - prepare Python Flask environment on EC2 instance,

      - download the Milliseconds Converter Application code from Github repository,
      
      - deploy the application on Flask Server.
   
   - EC2 Instances type can be configured as `t2.micro`.

   - Instance launched by Cloudformation should be tagged `Web Server of StackName` 

   - Milliseconds Converter Application Website URL should be given as output by Cloudformation Service, after the stack created.

## Project Skeleton 

```
002-milliseconds-converter (folder)
|
|----readme.md         # Given to the students (Definition of the project)          
|----cfn-template.yml  # To be delivered by students (Cloudformation template)
|----app.py            # To be delivered by students (Python Flask Web Application)
|----templates
        |----index.html  # Given to the students (HTML template)
        |----result.html # Given to the students (HTML template)
```

## Expected Outcome

### At the end of the project, following topics are to be covered;

- Algorithm design

- Programming with Python 

- Web application programming with Python Flask Framework 

- Bash scripting

- AWS EC2 Launch Template Configuration

- AWS EC2 Application Load Balancer Configuration

- AWS EC2 ALB Target Group Configuration

- AWS EC2 ALB Listener Configuration

- AWS EC2 Auto Scaling Group Configuration

- AWS EC2 Security Groups Configuration

- AWS Cloudformation Service

- AWS Cloudformation Template Design

- Git & Github for Version Control System

### At the end of the project, students will be able to;

- show their coding skills using boolean/math operators, string formatting, if statements and functions within Python.

- apply web programming skills using HTTP GET/POST methods, template formatting, importing packages within Python Flask Framework

- demonstrate bash scripting skills using `user data` section within launch template in Cloudformation to install and setup web application on EC2 Instance.

- demonstrate their configuration skills of AWS EC2 Launch Templates, Application Load Balancer, ALB Target Group, ALB Listener, Auto Scaling Group and Security Groups.

- configure Cloudformation template to use AWS Resources.

- show how to use AWS Cloudformation Service to launch stacks.

- apply git commands (push, pull, commit, add etc.) and Github as Version Control System.

## Steps to Solution
  
- Step 1: Download or clone project definition from `clarusway-aws-workshop` repo on Github

- Step 2: Create project folder for local public repo on your pc

- Step 3: Write the Milliseconds Converter Application in Python

- Step 4: Transform your application into web application using Python Flask framework

- Step 5: Prepare a cloudformation template to deploy your app on Application Load Balancer

- Step 6: Push your application into your own public repo on Github

- Step 7: Deploy your application on AWS Cloud using Cloudformation template to showcase your app

## Notes

- Use the template formatting library `jinja` within Flask framework to leverage from given templates.

- Use given html templates to warn user with invalid inputs.

- Customize the application by hard-coding your name for the `developer_name` variable within html templates.

- Use AWS CLI commands to get subnet ids of the default VPCs.

```bash
aws ec2 describe-subnets --no-paginate --filters "Name=default-for-az,Values=true" | egrep "(VpcId)|(SubnetId)"
```

## Resources

- [Python Flask Framework](https://flask.palletsprojects.com/en/1.1.x/quickstart/)

- [Python Flask Example](https://realpython.com/flask-by-example-part-1-project-setup/)

- [AWS Cloudformation User Guide](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/Welcome.html)

- [AWS CLI Command Reference](https://docs.aws.amazon.com/cli/latest/index.html)
