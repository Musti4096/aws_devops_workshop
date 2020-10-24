# Hands-on Boto3-01 : Installation, Configuration and Examples of Boto3 

## Outline

- Part 1 - Installation and Configuration

- Part 2 - Examples of Boto3 usage


## Part 1 - Installation and Configuration

- To install Boto3, open your terminal (Commands below works also for Command Prompt-Windows), and type the code below for the latest version.

```text
pip install boto3
```

- If you are using Python3, try:

```text
pip3 install boto3
```
- To be able to use Boto3, you need to configure AWS CLI. If you have AWS CLI installed and configured you don't need to do anything. 

```text
aws configure
```
- Then enter the credentials:

```text
AWS Access Key ID [****************EMOJ]: 
AWS Secret Access Key [****************/aND]: 
Default region name [us-east-1]: 
Default output format [json]: 
```


## Part 2 - Examples of Boto3 usage

### STEP-1: List your S3 Buckets:


- Open your Python IDE  and write the code below. To be able to use Boto3, first you need to import it (import boto3), then you can type other commands regarding it.


```text
import boto3

# Use Amazon S3
s3 = boto3.resource('s3')

# Print out all bucket names
for bucket in s3.buckets.all():
    print(bucket.name)
```

- Show that you can see the S3 buckets.


### STEP-2: Upload a file to the S3 Bucket

- You need an S3 bucket and a file in your working directory (test.jpg for this case) to upload.  

- Create a bucket named "my-bucket.clarusway"

```text
Region                      : US East (N.Virginia)
Versioning                  : Disable
Server access logging       : Disabled
Tagging                     : 0 Tags
Object-level logging        : Disabled
Default encryption          : None
CloudWatch request metrics  : Disabled
Object lock                 : Disabled
Block all public access     : Checked (Not Public)
```

- Create a file in your working directory named "test.jpg"

- Then type the code seen below.

```text
import boto3

# Use Amazon S3
s3 = boto3.resource('s3')

# Upload a new file
data = open('test.jpg', 'rb')
s3.Bucket('my-bucket.clarusway').put_object(Key='test.jpg', Body=data)
```
- Check the "my-bucket.clarusway", if your script works fine, you should be able to see your test file in your bucket.

### STEP-3: Upload a file to the S3 Bucket


- Type the code seen below to your IDE to create an Ubuntu instance. You may change the instance ID to create different types of instance .

```text
import boto3
ec2 = boto3.resource('ec2')

# create a new EC2 instance
instances = ec2.create_instances(
     ImageId='ami-0dba2cb6798deb6d8',
     MinCount=1,
     MaxCount=1,
     InstanceType='t2.micro',
     KeyName='yourkeypair without .pem'
 )
```

- Checked the newly created instance

- Then stop and terminate EC2 instance via boto3


```text
import boto3
ec2 = boto3.resource('ec2')
ec2.Instance('your InstanceID').stop()
```

```text
import boto3
ec2 = boto3.resource('ec2')
ec2.Instance('your InstanceID').terminate()
```
- Check the EC2 instance status from console.