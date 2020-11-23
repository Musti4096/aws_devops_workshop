# Hands-on Jenkins-06 : Building Jenkins Pipelines on Amazon Linux 2 AWS EC2 Instance

Purpose of the this hands-on training is to teach the students how to build Jenkins jobs on Amazon Linux 2 EC2 instance, how to integrate GitHub with Jenkins, how to integrate Docker as an agent, how to use tests in a stage, how to push images to AWS ECR and how to manage a multi-container application with docker-compose.  


## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- configure Jenkins Server with Docker on Amazon Linux 2 EC2 instance using Cloudformation Service.

- integrate Jenkins jobs with GitHub using Webhook.

- build simple Jenkins pipelines.

- build Jenkins pipelines with Jenkinsfile.

- integrate Jenkins pipelines with GitHub using Webhook.

- configure Jenkins Pipeline to compile Python code.

- configure Jenkins Pipeline to test Python code.

- configure Jenkins Pipeline to build Docker images using Dockerfile.

- configure Jenkins Pipeline to push a Docker images to AWS ECR.

- configure Jenkins Pipeline to start a multi-container application with docker-compose.


## Outline

- Part 1 - Installing Jenkins on Docker Using Cloudformation Template

- Part 2 - Integrating Jenkins with GitHub Using Webhook

- Part 3 - Creating a Jenkins Pipeline with Jenkinsfile to Compile the Code

- Part 4 - Configuring Jenkinsfile to Test the Code

- Part 5 - Configuring Jenkinsfile to Build the Docker Image

- Part 6 - Configuring Jenkinsfile to Push the Image to ECR

- Part 7 - Configuring Jenkinsfile to Start the Application


## Part 1 - Installing Jenkins on Docker Using Cloudformation Template

- Explain what [Clarusway Jenkins Server Cloudformation Template](./jenkins-server-cfn-template.yml) does.

- Launch a pre-configured `Clarusway Jenkins Server` using the [Clarusway Jenkins Server Cloudformation Template](./jenkins-server-cfn-template.yml) running on Amazon Linux 2, allowing SSH (port 22) and HTTP (ports 80, 8080) connections.

- Connect to your instance with SSH to check if the necessary installations are accomplished.

    ```bash
    $ ssh -i <path-to-your-pem-file> ec2-user@<ip-address-of-the-instance>
    ```
    ```bash
    $ docker --version
    $ systemctl status docker
    $ java -version
    $ systemctl status jenkins
    ```

- Get the administrator password from `var/jenkins_home/secrets/initialAdminPassword` file.

    ```bash
    $ cat /var/jenkins_home/secrets/initialAdminPassword
    ```

- Enter the temporary password to unlock the Jenkins.

- Create a user with desired credentials.

- Check the URL, then save and finish the installation.

- Open your Jenkins dashboard and navigate to `Manage Jenkins` >> `Manage Plugins` >> `Available` tab

- Search and select `GitHub Integration, Pipeline:GitHub, Docker, Docker Pipeline` plugins, then click to `Install without restart`. Note: No need to install the other `Git plugin` which is already installed can be seen under `Installed` tab.


## Part 2 - Integrating Jenkins with GitHub Using Webhook

- Create a public project repository `jenkins-python-project` on your GitHub account.

- Clone the `jenkins-python-project` repository on your local computer.

- Obtain the project's necessary files and folders (namely ```jenkins-server-cfn-template.yml, requirements.txt files and the src folder```) from this repo.

- Commit and push the local changes to update the remote repo on GitHub.

```bash
git add .
git commit -m 'initial commit'
git push
```

- Go back to Jenkins dashboard and click on `New Item` to create a new job item.

- Enter `python-docker-ecr-compose-pipe` then select `pipeline` and click `OK`.

- Enter `This pipeline compiles a python application, make tests on it, creates images, pushes an image to ecr and starts the application with docker-compose` in the description field.

- Put a checkmark on `Git` under `Source Code Management` section, enter URL of the project repository, and let others be default.

```text
<url-to-our-github-repo>
```

- Put a checkmark on `GitHub hook trigger for GITScm polling` under `Build Triggers` section.

- Under `Pipeline` section click on `Definition` and select `Pipeline script from SCM`.

- Click on `SCM` field and select `Git`.

- Paste your GitHub Repository URL into `Repository URL` field. Leave the rest as default.

- Click on `Apply` and `Save`.

- Go to GitHub `jenkins-python-project` repository page and click on `Settings`.

- Click on the `Webhooks` on the left hand menu, and then click on `Add webhook`.

- Copy the Jenkins URL from the AWS Management Console, paste it into `Payload URL` field, add `/github-webhook/` at the end of URL, and click on `Add webhook`.

```text
http://<your-jenkins-server-ip>:8080/github-webhook/
```

- Check the green check mark on the link.


## Part 3 - Creating a Jenkins Pipeline with Jenkinsfile to Compile the Code

- Go to your project's root folder on you local computer.

- Create a file with the name `Jenkinsfile`.

- Paste the lines below into your `Jenkinsfile`.

```Jenkinsfile
pipeline{
    agent any
    environment {
        MYSQL_DATABASE_HOST = "database-42.cbanmzptkrzf.us-east-1.rds.amazonaws.com"
        MYSQL_DATABASE_PASSWORD = "Clarusway"
        MYSQL_DATABASE_USER = "admin"
        MYSQL_DATABASE_DB = "phonebook"
        MYSQL_DATABASE_PORT = 3306
    }
    stages{
        stage("compile"){
            agent{
                docker{
                    image 'python:alpine'
                }
            }
            steps{
                withEnv(["HOME=${env.WORKSPACE}"]) {
                    sh 'pip install -r requirements.txt'
                    sh 'python -m py_compile src/*.py'
                    stash(name: 'compilation_result', includes: 'src/*.py*')
                }   
            }
        }
    }
}
```

- At that point, you can create your own RDS database and change MYSQL_DATABASE_HOST environment variable above with the end-point given. 

- Go to the project page and click `Build Now`. (First build may not be triggered by GitHub push event...)

- Commit and push the local changes to update the remote repo on GitHub.

```bash
git add .
git commit -m 'Added Jenkinsfile'
git push
```

- Explain the results.

- Explain the pipeline script.


## Part 4 - Configuring Jenkinsfile to Test the Code

- Go back to your project folder and explain what src/appTest.py file does.

- Add the below lines into the Jenkinsfile inside the stages scope.

```Jenkinsfile
stage('test') {
    agent {
        docker {
            image 'python:alpine'
        }
    }
    steps {
        withEnv(["HOME=${env.WORKSPACE}"]) {
            sh 'python -m pytest -v --junit-xml results.xml src/appTest.py'
        }
    }
    post {
        always {
            junit 'results.xml'
        }
    }
}
```

- Commit and push the local changes to update the remote repo on GitHub.

```bash
git add .
git commit -m 'Updated Jenkinsfile with test stage'
git push
```

- Pushing the code into GitHub should trigger the build in Jenkins Server.

- Explain the lines added to `Jenkinsfile` and the results.


## Part 5 - Configuring Jenkinsfile to Build the Docker Image

- Copy the Dockerfile from this repository and paste it into the project folder on your local computer.

- Explain what the Dockerfile does.

- Go to AWS ECR console and create a repository for the project.

- Copy the URL of the repository.

- Add the following lines by changing the ECR Repo name and URL into the Jenkinsfile.

```Jenkinsfile
stage('build'){
    agent any
    steps{
        sh "docker build -t <namespace>/<project-name> ."
        sh "docker tag <namespace>/<project-name> <your-ecr-url>/<namespace>/<project-name>:latest"
    }
}
```

- Commit and push the change to the remote repo on GitHub.

```bash
git add .
git commit -m 'Updated Jenkinsfile with build stage'
git push
```

- Observe the new built triggered with `git push` command under `Build History` on the Jenkins project page.

- Explain the results.

- Check if the image is created in the EC2 machine.


## Part 6 - Configuring Jenkinsfile to Push the Image to ECR

- Add the following lines into the Jenkinsfile.

```Jenkinsfile
stage('push'){
    agent any
    steps{
        sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 046402772087.dkr.ecr.us-east-1.amazonaws.com"
        sh "docker push 046402772087.dkr.ecr.us-east-1.amazonaws.com/matt/handson-jenkins:latest"
    }
}
```
- Add the following line into ```environment``` section in the Jenkins file.

```text
PATH="/usr/local/bin/:${env.PATH}"
```

- Explain why we did so.

- Now, go to ECR again, click on your repository and then click on the ```View push commands``` button.

- Copy the login command from the pop-up screen and update the push stage. 

- Copy the push command from the pop-up screen and update the push stage again.

- Commit and push the changes to the remote repo on GitHub.

```bash
git add .
git commit -m 'Updated jenkinsfile with push stage'
git push
```

- Observe the trigger with `git push` command on the Jenkins project page.

- Explain the build result.

- Go to ECR to check if the artifact is pushed or not.


## Part 7 - Configuring Jenkinsfile to Start the Application

- Copy the docker-compose.yml file from this repository and paste it into the project folder on your local computer.

- Explain what the file does.

- Add the following lines into the Jenkinsfile.

```Jenkinsfile
stage('compose'){
    agent any
    steps{
        sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 046402772087.dkr.ecr.us-east-1.amazonaws.com"
        sh "docker-compose up -d"
    }
}
```

- Change the first step with ```push``` stage's first step.

- Commit and push the changes to the remote repo on GitHub.

```bash
git add .
git commit -m 'Updated jenkinsfile with compose stage'
git push
```

- Open up a new tab on your browser and go to the URL of your ```Jenkins Server``` ip and show the result of the project.