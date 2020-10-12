# Hands-on Lambda-02 : Setting S3 Bucket, CORS event, Lambda and API Gateway

The topics for this hands-on session will be AWS Lambda, function as a service (FaaS). During this Playground you will create a website hosted on AWS S3 using AWS Lambda and Amazon API Gateway to add dynamic functionality to the site.

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- Create a static website on S3 bucket.

- Create a lambda function, that generates a random number and another function that processes form GET and PUT requests.

- Use API Gateway to expose lambda function to static website hosted on S3 bucket.


## Outline

- Part 1 - Prep - Creating a static web hosting on S3

- Part 2 - Creating a CORS event on S3 Bucket

- Part 3 - Cerate a Lambda Function with API Gateway



## Part 1 - Prep - Launching an Instance

STEP 1 : Prep - Creating a static web hosting on S3

![lab-001 Static Website](https://raw.githubusercontent.com/ForestTechnologiesLtd/devopsplayground11-lambda/master/diagrams/pg11-lab-001.png)


- Go to S3 menu using AWS console

- Create a bucket of `clarusway.broadcast` with following properties,

```text
Region                      : US East (N.Virginia)
Versioning                  : Disable
Server access logging       : Disabled
Tagging                     : 0 Tags
Object-level logging        : Disabled
Default encryption          : None
CloudWatch request metrics  : Disabled
Object lock                 : Disabled
Block all public access     : Unchecked (Public)

PS: Please, do not forget to select "US East (N.Virginia)" as Region
```
- Upload files from folder part-001_website
```
1. Select files
  - (all files minus css folder)
  - Click 'Next'
2. Set Permissions
  - Click 'Next'
3. Set Properties
  - Click 'Upload'
```


- Create subfolder css using S3 web console
  - Goto bucket "clarusway.broadcast"
  - Click Create folder
  - Name: css
  - Click 'Save'
  - Upload css folder.

- Set the static website bucket policy as shown below (`PERMISSIONS` >> `BUCKET POLICY`) and change `bucket-name` with your own bucket.

```json
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

- Enable Static website hosting

- Properties > Static website hosting
```
- Select 'Use this bucket to host a Website'

- Index document: index.html

- Error document: error.html

- Click 'Save'
```

- Open the Endpoint in a web browser.
http://clarusway.broadcast.s3-website-us-east-1.amazonaws.com

and click the sub-links and show the massages


## Part 2 - Creating a CORS event on S3 Bucket

![lab-002 Static Website using CORS](https://raw.githubusercontent.com/ForestTechnologiesLtd/devopsplayground11-lambda/master/diagrams/pg11-lab-002.png)

STEP 1: Upload new html files

- Go to S3 bucket named "clarusway.broadcast"

- Upload files from folder part-002_CORS:
  - cors.html
  - demo_text.html 

- Open the Endpoint in a web browser and show CORS sub-link.
http://clarusway.broadcast.s3-website-us-east-1.amazonaws.com

With a web browser visit the static website from Part-001 and click on the menu item 'CORS' the RED text "LAB NOT STARTED" should disappeared if not refresh the web page.
Click on the button Get External Content. Javascript code you edited at the start of this lab has now pull text from the file demo_text.

STEP 2 : Create Second S3 Bucket for using CORS 

- Create a bucket of `clarusway.cors.broadcast` with following properties,


```text
Region                      : US East (N.Virginia)
Versioning                  : Disable
Server access logging       : Disabled
Tagging                     : 0 Tags
Object-level logging        : Disabled
Default encryption          : None
CloudWatch request metrics  : Disabled
Object lock                 : Disabled
Block all public access     : Unchecked (Public)

PS: Please, do not forget to select "US East (N.Virginia)" as Region
```

- Set the static website bucket policy as shown below (`PERMISSIONS` >> `BUCKET POLICY`) and change `bucket-name` with your own bucket.

```json
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

- Upload files from the folder Part-002_cors\cors_bucket to your new bucket "clarusway.cors.broadcast"
  - cors_demo_text.txt
  - index.html
  - error.html

- Accept defaults, click 'Upload'

- Enable Static website hosting
```text
Properties > Static website hosting
Select 'Use this bucket to host a Website'
Index document: index.html
Error document: error.html
Click 'Save'
```
-Open the Endpoint in a web browser.
http://clarusway.cors.broadcast.s3-website-us-west-2.amazonaws.com

show that CORS option still inactive but page is running


- Open Part-002_cors\cors.html 

- find the "demo_text.txt" script in the html file

- REPLACE: demo_text.txt WITH: http://clarusway.cors.broadcast.s3-website-us-east-1.amazonaws.com/cors_demo_text.txt (URl of the cors_demo_text.txt file in the clarusway.cors.broadcast)

- upload this file to the S3 bucket named "clarusway.broadcast"

- Click on the button Get External Content in  the sub-link CORS. You will notice that nothing happens or sometimes it can be raised an error.
```text
This occurs because web browsers expect resources to be requested from the same domain. To resolve this issue AWS S3 has a feature called CORS (Cross Origin Resource Sharing) if you enable this feature this will allow the webpage to request the content from another bucket.
```

- With bucket clarusway.cors.broadcast enable CORS configuration, add a new policy.
```text
Permissions > CORS configuration
NOTE: Replace url in <AllowedOrigin> tag with your static website link from Part-1.
```

```bash
<?xml version="1.0" encoding="UTF-8"?>
<CORSConfiguration xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
<CORSRule>
    <AllowedOrigin>http://clarusway.broadcast.s3-website-us-west-2.amazonaws.com</AllowedOrigin>
    <AllowedMethod>GET</AllowedMethod>
    <MaxAgeSeconds>3000</MaxAgeSeconds>
    <AllowedHeader>Authorization</AllowedHeader>
</CORSRule>
</CORSConfiguration>
```
- Click "Save"

- go to browser and refresh the web-page and show the CORS sub-link. 


## Part 3 - Create a Lambda Function with API Gateway

![lab-003 Static Website with API Gateway and Lambda](https://raw.githubusercontent.com/ForestTechnologiesLtd/devopsplayground11-lambda/master/diagrams/pg11-lab-003.png)

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
    myNumber = randint(0,1000)
    print("Random No. [ %s ]" % myNumber)
    return myNumber
```
- Click "DEPLOY" button

- In the sub-menu of configuration go to the "Basic settings section" and click edit
```
Description : Function that generates a random number between 0 and 1000

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
You will see the message Execution result: succeeded(logs) and a random number in a box with a dotted line.


STEP 3 : Create New 'API'

- Go to API Gateway on AWS Console

- Click "Create API"

- Select REST API ----> Build
```

Choose the protocol : REST
Create new API      : New API
Settings            :

  - Name: ClarusAPI
  - Description: test lab api
  - Endpoint Type: Regional
  - Click 'Create API'
```

STEP 4 : Exposing Lambda via API Gateway

- 1. Add a New Child Resource

- APIs > ClarusAPI > Resources > /

- Click on Actions > 'Create Resource'

New Child Resource
  - Configure as proxy resource: Leave blank
  - Resource Name: Random Number
  - Resource Path: /random-number
  - Enable API Gateway CORS: Yes
  - Click 'Create Resource' button

- 2. Add a GET method to resource /

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

- Click GET method under /random-number

- Click TEST link in the box labeled 'Client At the bottom of the new view Click 'Test' button

- Under Response Body you should see a random number. Click the blue button labelled 'Test' again at the bottom of the screen and you will see a new number appear.

- Test completed successfully

STEP 6 : Deploy API

- Click Resources select /random-number

- Select Actions and select Deploy API
```
Deployment stage: [New Stage]
Stage Name: dev
Stage description: Generate Number stage
Deployment description: Part-3
```

- it can be seen invoke URL on top like;
"https://d3w0w4ajyh.execute-api.eu-central-1.amazonaws.com/dev" and note it down somewhere.

- Entering the Invoke URL into the web browser and add "/random-number" at the end of the URL. Show the generated random number with refreshing the page in the web browser.


STEP 7: Implementation of the API

- Open and Edit the file "apigw.html" in the Part-3 folder change the link and replace the string 'MY_API_GW_REQUEST' with the API Gateway Invoke URL e.g. "https://d3w0w4ajyh.execute-api.eu-central-1.amazonaws.com/dev"

- Go to S3 Bucket menu and select "clarusway.broadcast" bucket ---> Upload "apigw.html" file into the bucket.

- Copy Bucket's static website Endpoint and paste it to browser. 

- Show the sub-link "API Gateway" and click the button of "Get External Content" ----> It will fail.

- View Javascript in your website and you'll see message like CORS header 'Access-Control-Allow-Origin' missing.

STEP 8: Active CORS on API

- Previous part we did learned what CORS. You need to enable the API here so the website can access the link.

- Go to the API /random-number, GET method then Actions > Enable CORS

- Click 'Enable CORS and replace existing CORS headers' button and keep the rest of page as is.

- Confirm dialog 'Yes, replace existing values'

- Watch the animated ticks appear on the AWS console

- You need to redeploy the API; 
  - Select / ---> Actions ---> Deploy API
      - Development stage: dev
      - Development description: Part-3 CORS enabled GET request
      - Click 'Deploy'

- Refresh the web page and go to API Gateway sub-link 

- Press button Get External Content and show the random number created by Lambda function. 