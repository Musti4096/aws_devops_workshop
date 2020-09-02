# Hands-on Flask-02 : Handling Routes and Templates with Flask Web Application

Purpose of the this hands-on training is to give the students introductory knowledge of how to handle routes and use html templates within a Flask web application on Amazon Linux 2 EC2 instance. 

## Learning Outcomes

At the end of the hands-on training, students will be able to;

- install Python and Flask framework on Amazon Linux 2 EC2 instance

- build a simple web application with Flask framework.

- understand the HTTP request-response cycle and structure of URL.

- create routes (or views) with Flask.

- serve static content and files using Flask.

- serve dynamic content using the html templates.

- write html templates using Jinja Templating Engine.

## Outline

- Part 1 - Getting to know routing and HTTP URLs.

- Part 2 - Install Python and Flask framework Amazon Linux 2 EC2 Instance 

- Part 3 - Write a Web Application with Sample Routings and Templating on GitHub Repo

- Part 4 - Run the Web App on EC2 Instance

## Part 1 - Getting to know routing and HTTP URLs.

HTTP (Hypertext Transfer Protocol) is a request-response protocol. A client on one side (web browser) asks or requests something from a server and the server on the other side sends a response to that client. When we open our browser and write down the URL (Uniform Resource Locator), we are requesting a resource from a server and the URL is the address of that resource. The structure of typical URL is as the following.

![URL anatomy](./url-structure.png)

The server responds to that request with an HTTP response message. Within the response, a status code element is a 3-digit integer defines the category of response as shown below.

- 1xx -> Informational

- 2xx -> Success

- 3xx -> Redirection

- 4xx -> Client Error

- 5xx -> Server Error

## Part 2 - Install Python and Flask framework Amazon Linux 2 EC2 Instance 

- Launch an Amazon EC2 instance using the Amazon Linux 2 AMI with security group allowing SSH (Port 22) and HTTP (Port 80) connections.

- Connect to your instance with SSH.

- Update the installed packages and package cache on your instance.

- Install `Python 3` packages.

- Check the python3 version

- Install `Python 3 Flask` framework.

- Check the versions of Flask framework packages (flask, click, itsdangerous, jinja2, markupSafe, werkzeug)

## Part 3 - Write a Web Application with Sample Routings and Templating on GitHub Repo

- Create folder named `flask-02-handling-routes-and-templates-on-ec2-linux2` within `clarusway-python-workshop` repo

- Create python file named `app.py`

- Write an application with routing and templating samples and save the complete code under `hands-on/flask-02-handling-routes-and-templates-on-ec2-linux2` folder.

```python
#Import Flask modules

#Create an object named app 

# Create a function named home which returns a string 'This is home page for no path, <h1> Welcome Home</h1>' 
# and assign route of no path ('/')

# Create a function named about which returns a formatted string '<h1>This is my about page </h1>' 
# and assign to the static route of ('about')

# Create a function named error which returns a formatted string '<h1>Either you encountered an error or you are not authorized.</h1>' 
# and assign to the static route of ('error')

# Create a function named hello which returns a string of '<h1>Hello, World! </h1>' 
# and assign to the static route of ('/hello')

# Create a function named admin which redirect the request to the error path 
# and assign to the route of ('/admin')

# Create a function named greet which return formatted inline html string 
# and assign to the dynamic route of ('/<name>')

# Create a function named greet_admin which redirect the request to the hello path with param of 'Master Admin!!!!' 
# and assign to the route of ('/greet-admin')

# Rewrite a function named greet which which uses template file named `greet.html` under `templates` folder 
# and assign to the dynamic route of ('/<name>')

# Create a function named list10 which creates a list counting from 1 to 10 within `list10.html` 
# and assign to the route of ('/list10')

# Create a function named evens which show the even numbers from 1 to 10 within `evens.html` 
# and assign to the route of ('/evens')

# Add a statement to run the Flask application which can be reached from any host on port 80.
```

- Write a template html file named `greet.html` which takes `name` as parameter under `templates` folder 

- Write a template html file named `list10.html` which shows a list counting from 1 to 10 under `templates` folder 

- Write a template html file named `evens.html` which shows a list of even numbers from 1 to 10 under `templates` folder 

- Create a folder named `static` under `hands-on/flask-02-handling-routes-and-templates-on-ec2-linux2` folder and create a text file named `mytext.txt` with *This is a text file in static folder* content.

- Add and commit all changes on local repo

- Push `app.py`, `greet.html`, `list10.html`, `evens.html`, and `mytext.txt` to remote repo `clarusway-python-workshop` on GitHub.

## Part 4 - Run the Hello World App on EC2 Instance

- Download the web application file from GitHub repo.

- Run the web application

- Connect the route handling and templating web application from the web browser and try every routes configured

- Open the static file `mytext.txt` context from the web browser

- Connect the route handling and templating web application from the terminal with `curl` command.

