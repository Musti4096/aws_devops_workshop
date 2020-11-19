# Hands-on Jenkins-03 : Building Jenkins Pipelines on Amazon Linux 2 AWS EC2 Instance

Purpose of the this hands-on training is to teach the students how to build Jenkins jobs on Amazon Linux 2 EC2 instance.

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- configure Jenkins Server on Docker on Amazon Linux 2 EC2 instance using Cloudformation Service.

- integrate Jenkins jobs with GitHub using Webhook.

- build simple Jenkins pipelines.

- build Jenkins pipelines with Jenkinsfile.

- integrate Jenkins pipelines with GitHub using Webhook.

- configure Jenkins Pipeline to build Python code.

- configure Jenkins Pipeline to build Java code.

- configure Jenkins Pipeline to build Maven project.

## Outline

- Part 1 - Installing Jenkins on Docker using Cloudformation Template

- Part 2 - Integrating Jenkins with GitHub using Webhook

- Part 3 - Creating a Simple Pipeline with Jenkins

- Part 4 - Creating a Jenkins Pipeline with Jenkinsfile

- Part 5 - Integrating Jenkins Pipeline with GitHub Webhook

- Part 6 - Configuring Jenkins Pipeline with GitHub Webhook to Run the Python Code

- Part 7 - Configuring Jenkins Pipeline with GitHub Webhook to Build the Java Code

- Part 8 - Configuring Jenkins Pipeline with GitHub Webhook to Build the a Java Maven Project

## Part 1 - Install Jenkins on Docker using Cloudformation Template

- Launch a pre-configured `Clarusway Jenkins Server` from the AMI of Clarusway (ami-0644c22f90412d908) running on Amazon Linux 2, allowing SSH (port 22) and HTTP (ports 80, 8080) connections using the [Clarusway Jenkins Server Cloudformation Template](./clarusway-jenkins-on-docker-cfn-template.yml). Clarusway Jenkins Server is configured with admin user `call-jenkins` and password `Call-jenkins1234`.

- Or launch and configure a Jenkins Server on Amazon Linux 2 AMI with security group allowing SSH (port 22) and HTTP (ports 80, 8080) connections using the [Cloudformation Template for Jenkins on Docker Installation](./jenkins-on-docker-cfn-template.yml).

  - Connect to your instance with SSH.

    ```bash
    ssh -i .ssh/call-training.pem ec2-user@ec2-3-133-106-98.us-east-2.compute.amazonaws.com
    ```

  - Get the administrator password from `var/jenkins_home/secrets/initialAdminPassword` file.

    ```bash
    docker exec -it jenkins bash
    cat /var/jenkins_home/secrets/initialAdminPassword
    exit
    ```

  - The administrator password can also be taken from Docker logs.

    ```bash
    docker logs jenkins
    ```

  - Enter the temporary password to unlock the Jenkins.

  - Install suggested plugins.

  - Create first admin user (`call-jenkins:Call-jenkins1234`).

  - Check the URL, then save and finish the installation.

  - Open your Jenkins dashboard and navigate to `Manage Jenkins` >> `Manage Plugins` >> `Available` tab

  - Search and select `GitHub Integration` plugin, then click to `Install without restart`. Note: No need to install the other `Git plugin` which is already installed can be seen under `Installed` tab.

## Part 2 - Integrating Jenkins with GitHub using Webhook

- Create a public project repository `jenkins-first-project` on your GitHub account.

- Clone the `jenkins-first-project` repository on local computer.

- Write a simple python code which prints `Hello World` and save it as `hello-word.py`.

```python
print('Hello World')
```

- Commit and push the local changes to update the remote repo on GitHub.

```bash
git add .
git commit -m 'added hello world'
git push
```

- Go back to Jenkins dashboard and click on `New Item` to create a new job item.

- Enter `first-job-triggered` then select `free style project` and click `OK`.

- Enter `My first job triggered from GitHub` in the description field.

- Put a checkmark on `Git` under `Source Code Management` section, enter URL of the project repository, and let others be default.

```text
https://github.com/callahan-cw/jenkins-first-project/
```

- Put a checkmark on `GitHub hook trigger for GITScm polling` under `Build Triggers` section, and click `apply` and `save`.

- Go to the `jenkins-first-project` repository page and click on `Settings`.

- Click on the `Webhooks` on the left hand menu, and then click on `Add webhook`.

- Copy the Jenkins URL from the AWS Management Console, paste it into `Payload URL` field, add `/github-webhook/` at the end of URL, and click on `Add webhook`.

```text
http://ec2-54-144-151-76.compute-1.amazonaws.com:8080/github-webhook/
```

- Change the python code to print `Hello World for Jenkins Job` and save.

```python
print('Hello World for Jenkins Job')
```

- Commit and push the local changes to update the remote repo on GitHub.

```bash
git add .
git commit -m 'updated hello world'
git push
```

- Observe the new built under `Build History` on the Jenkins project page.

- Explain the details of the built on the Build page.

- Go back to the project page and explain the GitHub Hook log.

## Part 3 - Creating a Simple Pipeline with Jenkins

- Go to the Jenkins dashboard and click on `New Item` to create a pipeline.

- Enter `simple-pipeline` then select `Pipeline` and click `OK`.

- Enter `My first simple pipeline` in the description field.

- Go to the `Pipeline` section, enter following script, then click `apply` and `save`.

```text
pipeline {
    agent { label 'master' }
    stages {
        stage('build') {
            steps {
                echo "Clarusway_Way to Reinvent Yourself"
                sh 'echo second step'
                sh 'echo another step'
                sh '''
                echo 'Multiline'
                echo 'Example'
                '''
                echo 'not using shell'
            }
        }
    }
}
```

- Go to the project page and click `Build Now`.

- Explain the built results.

- Explain the pipeline script.

## Part 4 - Creating a Jenkins Pipeline with Jenkinsfile

- Go to the Jenkins dashboard and click on `New Item` to create a pipeline.

- Enter `pipeline-from-jenkinsfile` then select `Pipeline` and click `OK`.

- Enter `Simple pipeline configured with Jenkinsfile` in the description field.

- Go to the `Pipeline` section, and select `Pipeline script from SCM` in the `Definition` field.

- Select `Git` in the `SCM` field.

- Enter URL of the project repository, and let others be default.

```text
https://github.com/callahan-cw/jenkins-first-project/
```

- Click `apply` and `save`. Note that the script `Jenkinsfile` should be placed under root folder of repo.

- Create a `Jenkinsfile` within the `jenkins-first-project` repo and save following pipeline script.

```groovy
pipeline {
    agent { label 'master' }
    stages {
        stage('build') {
            steps {
                echo "Clarusway_Way to Reinvent Yourself"
                sh 'echo using shell within Jenkinsfile'
                echo 'not using shell in the Jenkinsfile'
            }
        }
    }
}
```

- Commit and push the local changes to update the remote repo on GitHub.

```bash
git add .
git commit -m 'added Jenkinsfile'
git push
```

- Go to the Jenkins project page and click `Build Now`.

- Explain the role of `Jenkinsfile` and the built results.

## Part 5 - Integrating Jenkins Pipeline with GitHub Webhook

- If you haven't done so far, go to the `jenkins-first-project` repository page and create a webhook.

- Go to the Jenkins dashboard and click on `New Item` to create a pipeline.

- Enter `pipeline-with-jenkinsfile-and-webhook` then select `Pipeline` and click `OK`.

- Enter `Simple pipeline configured with Jenkinsfile and GitHub Webhook` in the description field.

- Put a checkmark on `GitHub Project` under `General` section, enter URL of the project repository.

```text
https://github.com/callahan-cw/jenkins-first-project/
```

- Put a checkmark on `GitHub hook trigger for GITScm polling` under `Build Triggers` section.

- Go to the `Pipeline` section, and select `Pipeline script from SCM` in the `Definition` field.

- Select `Git` in the `SCM` field.

- Enter URL of the project repository, and let others be default.

```text
https://github.com/callahan-cw/jenkins-first-project/
```

- Click `apply` and `save`. Note that the script `Jenkinsfile` should be placed under root folder of repo.

- Create a `Jenkinsfile` within the `jenkins-first-project` repo and save following pipeline script.

```groovy
pipeline {
    agent { label 'master' }
    stages {
        stage('build') {
            steps {
                echo 'Clarusway_Way to Reinvent Yourself'
                sh 'echo Hello World'
            }
        }
    }
}
```

- Commit and push the local changes to update the remote repo on GitHub.

```bash
git add .
git commit -m 'added Jenkinsfile'
git push
```

- Go to the Jenkins project page and click `Build Now`.The job has to be executed manually one time in order for the push trigger and the git repo to be registered.

- Observe the manual built, explain the built results, and show the `Hello World` output from the shell.

- Now, to trigger an automated build on Jenkins Server, we need to change any file it the repo, then commit and push the change into the GitHub repository. So, update the `Jenkinsfile` with the following pipeline script.

```groovy
pipeline {
    agent { label 'master' }
    stages {
        stage('build') {
            steps {
                echo 'Clarusway_Way to Reinvent Yourself'
                sh 'echo Integrating Jenkins Pipeline with GitHub Webhook using Jenkinsfile'
            }
        }
    }
}
```

- Commit and push the change to the remote repo on GitHub.

```bash
git add .
git commit -m 'updated Jenkinsfile'
git push
```

- Observe the new built triggered with `git push` command under `Build History` on the Jenkins project page.

- Explain the built results, and show the `Integrating Jenkins Pipeline with GitHub Webhook using Jenkinsfile` output from the shell.

- Explain the role of `Jenkinsfile` and GitHub Webhook in this automation.

## Part 6 - Configuring Jenkins Pipeline with GitHub Webhook to Run the Python Code

- To build the `python` code with Jenkins pipeline using the `Jenkinsfile` and `GitHub Webhook`, we will leverage from the same job created in ***Part 5*** (named as `pipeline-with-jenkinsfile-and-webhook`). To accomplish this task, we need;

  - a python code to build

  - a python environment to run the pipeline stages on the python code

  - a Jenkinsfile configured for an automated build on our repo

- Create a python file on the `jenkins-first-project` GitHub repository, name it as `pipeline.py`, add coding to print `My first python job which is run within Jenkinsfile.` and save.

```python
print('My first python job which is run within Jenkinsfile.')
```

- Since the Jenkins Server is running on Docker Machine, we can leverage from docker image of python on alpine, to setup the python environment. Note that currently, alpine tag of the image is bound to python `version 3.8.5`.

- Update the `Jenkinsfile` with the following pipeline script, and explain the changes.

```groovy
pipeline {
    agent { docker { image 'python:alpine' } }
    stages {
        stage('run') {
            steps {
                echo 'Clarusway_Way to Reinvent Yourself'
                sh 'python3 --version'
                sh 'python3 pipeline.py'
            }
        }
    }
}
```

- For native structured Jenkins Server

```groovy
pipeline {
    agent any
    stages {
        stage('run') {
            steps {
                echo 'Clarusway_Way to Reinvent Yourself'
                sh 'python --version'
                sh 'python pipeline.py'
            }
        }
    }
}
```


- Commit and push the changes to the remote repo on GitHub.

```bash
git add .
git commit -m 'updated jenkinsfile and added pipeline.py'
git push
```

- Observe the new built triggered with `git push` command on the Jenkins project page.

- Explain the role of the docker image of Python, `Jenkinsfile` and GitHub Webhook in this automation.

## Part 7 - Configuring Jenkins Pipeline with GitHub Webhook to Build the Java Code

- To build the `java` code with Jenkins pipeline using the `Jenkinsfile` and `GitHub Webhook`, we will leverage from the same job created in ***Part 5*** (named as `pipeline-with-jenkinsfile-and-webhook`). To accomplish this task, we need;

  - a java code to build

  - a java environment to run the build stages on the java code

  - a Jenkinsfile configured for an automated build on our repo

- Create a java file on the `jenkins-first-project` GitHub repository, name it as `Hello.java`, add coding to print `Hello from Java` and save.

```java
public class Hello {

    public static void main(String[] args) {
        System.out.println("Hello from Java");
    }
}
```

- Since the Jenkins Server is running on Java platform, we can leverage from the already available java environment.

- Update the `Jenkinsfile` with the following pipeline script, and explain the changes.

- `yum install java-devel` to install java dependencies.

```groovy
pipeline {
    agent { label 'master' }
    stages {
        stage('build') {
            steps {
                echo 'Compiling the java source code'
                sh 'javac Hello.java'
            }
        }
        stage('run') {
            steps {
                echo 'Running the compiled java code.'
                sh 'java Hello'
            }
        }
    }
}
```

- Commit and push the changes to the remote repo on GitHub.

```bash
git add .
git commit -m 'updated jenkinsfile and added Hello.java'
git push
```

- Observe the new built triggered with `git push` command on the Jenkins project page.

- Explain the role of java environment, `Jenkinsfile` and GitHub Webhook in this automation.

## Part 8 - Configuring Jenkins Pipeline with GitHub Webhook to Build the a Java Maven Project

- To build the `java` maven project with Jenkins pipeline using the `Jenkinsfile` and `GitHub Webhook`. To accomplish this task, we need;

  - a java code to build

  - a java environment to run the build stages on the java code

  - a maven environment to run the build stages on the java code

  - a Jenkinsfile configured for an automated build on our repo

- Create a public project repository `jenkins-maven-project` on your GitHub account.

- Clone the `jenkins-maven-project` repository on local computer.

- Copy the files given within the hands-on folder [hello-app](./hello-app)  and paste under the `jenkins-maven-project` GitHub repo folder.

- Go to the Jenkins dashboard and click on `New Item` to create a pipeline.

- Enter `pipeline-with-jenkinsfile-and-webhook-for-maven-project` then select `Pipeline` and click `OK`.

- Enter `Simple pipeline configured with Jenkinsfile and GitHub Webhook for Maven project` in the description field.

- Put a checkmark on `GitHub Project` under `General` section, enter URL of the project repository.

```text
https://github.com/callahan-cw/jenkins-maven-project/
```

- Put a checkmark on `GitHub hook trigger for GITScm polling` under `Build Triggers` section.

- Go to the `Pipeline` section, and select `Pipeline script from SCM` in the `Definition` field.

- Select `Git` in the `SCM` field.

- Enter URL of the project repository, and let others be default.

```text
https://github.com/callahan-cw/jenkins-maven-project/
```

- Click `apply` and `save`. Note that the script `Jenkinsfile` should be placed under root folder of repo.

- Since the Jenkins Server is running on Docker Machine, we can leverage from docker image of maven to setup the java and maven environment.

- Create a `Jenkinsfile` with the following pipeline script, and explain the script.

```groovy
pipeline {
    agent {
        docker {
            image 'maven:3-openjdk-8'
            args '-v /root/.m2:/root/.m2'
        }
    }
    stages {
        stage('Build') {
            steps {
                sh 'mvn -B -DskipTests clean package'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
        stage('Deliver') {
            steps {
                sh 'chmod +x deliver-script.sh'
                sh './deliver-script.sh'
            }
        }
    }
}
```

- For native structured Jenkins Server

```groovy
pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh 'mvn -f hello-app/pom.xml -B -DskipTests clean package'
            }
            post {
                success {
                    echo "Now Archiving the Artifacts....."
                    archiveArtifacts artifacts: '**/*.jar'
                }
            }
        }
        stage('Test') {
            steps {
                sh 'mvn -f hello-app/pom.xml test'
            }
            post {
                always {
                    junit 'hello-app/target/surefire-reports/*.xml'
                }
            }
        }
    }
}
```

- Commit and push the changes to the remote repo on GitHub.

```bash
git add .
git commit -m 'added jenkinsfile and maven project'
git push
```

- Observe the new built triggered with `git push` command on the Jenkins project page.

- Explain the role of the docker image of maven, `Jenkinsfile` and GitHub Webhook in this automation.
