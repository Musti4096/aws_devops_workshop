# Hands-on Lambda-01 : Lambda Function and API Gateway.

The topics for this hands-on session will be AWS Lambda, function as a service (FaaS). During this Playground we will create two AWS S3 Buckets and using AWS Lambda to synchronize them. In addition, We will show tje association between Lambda and API Gateway.

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- Create a S3 bucket.

- Create Lambda Function

- Trigger the Lambda Function with S3 Bucket

- Create a lambda function, that generates a random city and trigger it with API Gateway.



## Outline

- Part 1 - Prep - Creating AWS S3 Bucket

- Part 2 - Creating a Lambda Function and Setting a Trigger Event

- Part 3 - Create a Lambda Function with API Gateway



## Part 1 - Prep - Creating a S3 Bucket

STEP 1 : Prep - Creating S3 Bucket

- Go to S3 menu using AWS console

- Create a bucket of `clarusway.source.lambda` with following properties,

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

PS: Please, do not forget to select "US East (N.Virginia)" as Region
```

- Create another bucket of `clarusway.destination.lambda` with following properties,

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

PS: Please, do not forget to select "US East (N.Virginia)" as Region
```


## Part 2 - Create a Lambda Function and Trigger Event

STEP 1: Create Lambda Function

- Go to Lambda Service on AWS Console

- Functions ----> Create Lambda function
```text
1. Select Author from scratch
  Name: s3Synchronize
  Runtime: Python 3.6
  Role: Create a new role with basic Lambda permissions
  Click 'Create function'
```

- In the sub-menu of configuration go to the "Basic settings section" and click edit
```
Description : Function that synchronize two buckets
- Click view created role by AWS at below

- This link will navigate you to IAM role window.

-Click Attach policies

- Select "AmazonS3FullAccess policy" ---> Attach policy

- Show that there is two policies existing and close the IAM page, turn into the "Basic settings" menu and save it.

P.S.: Accept Defaults for other settings
```

STEP 2: Setting Trigger Event

- Go to Configuration sub-menu and click AddTrigger on Designer  
```
Trigger Configuration : S3

- Bucket              : clarusway.source.lambda

- Event Type          : PUT

- Enable Trigger      : checked
```

STEP 3: Create Function Code

- Go to the Function Code sub-menu and paste code seen below:

```python
import json
import boto3

# boto3 S3 initialization
s3_client = boto3.client("s3")


def lambda_handler(event, context):
   destination_bucket_name = 'clarusway.destination.lambda'

   # event contains all information about uploaded object
   print("Event :", event)

   # Bucket Name where file was uploaded
   source_bucket_name = event['Records'][0]['s3']['bucket']['name']

   # Filename of object (with path)
   file_key_name = event['Records'][0]['s3']['object']['key']

   # Copy Source Object
   copy_source_object = {'Bucket': source_bucket_name, 'Key': file_key_name}

   # S3 copy object operation
   s3_client.copy_object(CopySource=copy_source_object, Bucket=destination_bucket_name, Key=file_key_name)

   return {
       'statusCode': 200,
       'body': json.dumps('Hello from S3 events Lambda!')
   }
```

- 

STEP 4: Testing S3 Bucket Synchronization


- Go to S3 Bucket Service

- Select S3 bucket named 'clarusway.source.lambda'

- Upload files Guile.png and Honda.png

- Go to the S3 bucket named 'clarusway.destination.lambda' and show the uploaded files to the source bucket.

- You can show some other functions if have enough time (Optional)

- Example 2: 

```python

def lambda_handler(event, context):
roman = ['M', 'CM', 'D', 'CD', 'C', 'XC', 'L', 'XL', 'X', 'IX', 'V', 'IV', 'I']
sayi = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]
romanvalue = ""
for i, d in enumerate(sayi):
   while (event['num'] >= d):
      event['num'] -= d
      romanvalue += roman[i]
return romanvalue
```

For testing: 

{
  "num": 2546
}

- Example 3: 

```python
from __future__ import print_function
from random import randint
print('Loading function')
def lambda_handler(event, context):
    myNumber = randint(1,3999)
    number = myNumber
    roman = ['M', 'CM', 'D', 'CD', 'C', 'XC', 'L', 'XL', 'X', 'IX', 'V', 'IV', 'I']
    sayi = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]
    romanvalue = ""
    for i, d in enumerate(sayi):
        while (myNumber >= d):
            myNumber -= d
            romanvalue += roman[i]
    return f'Roman Representation of the {number} is {romanvalue}'

```

For testing: 

{
 
}

## Part 3 - Create a Lambda Function with API Gateway


STEP 1: Create Lambda Function

- Go to Lambda Service on AWS Console

- Functions ----> Create Lambda function
```text
1. Select Author from scratch
  Name: NumberGenerator
  Runtime: Python 2.7
  Role: Create a new role with basic Lambda permissions
  Click 'Create function'
```

- Configuration of Function Code

- In the sub-menu of configuration go to the "Function code section" and paste code seen below

```python
from __future__ import print_function
from random import randint

print('Loading function')

def lambda_handler(event, context):
    myNumber = randint(0,8)
    mylist = ['Berlin', 'London', 'Athens', 'New York', 'Istanbul', 'Ankara', 'Brussels','Paris','Edirne']
    return mylist[myNumber]

```
- Click "DEPLOY" button

- In the sub-menu of configuration go to the "Basic settings section" and click edit
```
Description : Function that generates a random city

Accept Defaults for other settings
```


STEP 2: Testing your function - Create test event

Click 'Test' button and opening page Configure test events
```
Select: Create new test event
Event template: Hello World
Event name: emptyClarus
Input test event as;

{}

Click 'Create'
Click 'Test'
```
You will see the message Execution result: succeeded(logs) and a random city in a box with a dotted line.


STEP 3 : Create New 'API'

- Go to API Gateway on AWS Console

- Click "Create API"

- Select REST API ----> Build
```

Choose the protocol : REST
Create new API      : New API
Settings            :

  - Name: FirstAPI
  - Description: test first api
  - Endpoint Type: Regional
  - Click 'Create API'
```

STEP 4 : Exposing Lambda via API Gateway

- 1. Add a New Child Resource

- APIs > FirstAPI > Resources > /

- Click on Actions > 'Create Resource'

New Child Resource
  - Configure as proxy resource: Leave blank
  - Resource Name: city
  - Resource Path: /random-city (it has automatically appear)
  - Enable API Gateway CORS: Yes
  - Click 'Create Resource' button

- 2. Add a GET method to resource /city

- Actions > Create Method

- Under the resource a drop down will appear select GET method and click the 'tick'.

- 3. / GET - Method Execution
```
  - Integration type: Lambda Function
  - Use Lambda Proxy integration: Leave blank
  - Lambda Region: us-east-1
  - Lambda Function: generateNumber
  - Click 'Save'
  - Confirm the dialog 'Add Permission to Lambda Function', Click 'OK'
```

STEP 5: Testing Lambda via API Gateway

- Click GET method under /city

- Click TEST link in the box labeled 'Client At the bottom of the new view Click 'Test' button

- Under Response Body you should see a random number. Click the blue button labelled 'Test' again at the bottom of the screen and you will see a new number appear.

- Test completed successfully

STEP 6 : Deploy API

- Click Resources select /city

- Select Actions and select Deploy API
```
Deployment stage: [New Stage]
Stage Name: dev
Stage description: Generate stage
Deployment description: Part-3
```

- it can be seen invoke URL on top like;
"https://d3w0w4ajyh.execute-api.eu-central-1.amazonaws.com/dev" and note it down somewhere.

- Entering the Invoke URL into the web browser adding "/city"and show the generated city with refreshing the page in the web browser.
