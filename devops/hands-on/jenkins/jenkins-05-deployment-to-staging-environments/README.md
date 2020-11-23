# Hands-on Jenkins-05 : Building Jenkins Pipelines and Deploying Applications on Amazon Linux 2 AWS EC2 Instances

Purpose of the this hands-on training is to deploy a web application Tomcat server for staging and production environment.

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- configure Jenkins Server on Amazon Linux 2 EC2 instance using Cloudformation Service.

- configure Jenkins Server

- create views in Jenkins

- package application for staging environments

- install required plugins

- build Jenkins pipelines.

- build Jenkins pipelines with Jenkinsfile.

- update & rebuild Jenkins pipelines

- integrate Jenkins pipelines with SCM poll.

- configure Jenkins Pipeline to build Maven project.

## Outline

- Part 1 - Install Jenkins Natively using Cloudformation Template

- Part 2 - Install Java, Maven and Git packages

- Part 3 - Maven Settings

- Part 4 - Creating a view

- Part 5 - Creating Package Application - Free Style Maven Job

- Part 6 - Installing Plugins

- Part 7 - Deploy Application to Staging Environment

- Part 8 - Update the application and deploy to the staging environment

- Part 9 - Build Pipeline Plugin

- Part 10 - Deploy application to production environment

- Part 11 - Jenkins Job DSL

- Part 12 - Creating a Pipeline with Jenkins

- Part 13 - Automate Existing Maven Project as Pipeline with Jenkins

## Part 1 - Install Jenkins Natively using Cloudformation Template

- Launch and configure a Jenkins Server on Amazon Linux 2 AMI with security group allowing SSH (port 22) and HTTP (ports 80, 8080) connections using the [Cloudformation Template for Jenkins Native Installation](../jenkins-02-building-jenkins-job/jenkins-native-install-cfn-template.yml).

  - Connect to your instance with SSH.

    ```bash
    ssh -i .ssh/call-training.pem ec2-user@ec2-3-133-106-98.us-east-2.compute.amazonaws.com
    ```

  - Get the administrator password from `/var/lib/jenkins/secrets/initialAdminPassword` file with `sudo cat /var/lib/jenkins/secrets/initialAdminPassword`

  - Enter the temporary password to unlock the Jenkins.

  - Install suggested plugins.

  - Create first admin user (`call-jenkins:Call-jenkins1234`).

  - Check the URL, then save and finish the installation.

  - Open your Jenkins dashboard and navigate to `Manage Jenkins` >> `Manage Plugins` >> `Available` tab

  - Search and select `GitHub Integration` plugin, then click to `Install without restart`. Note: No need to install the other `Git plugin` which is already installed can be seen under `Installed` tab.

# Configuration of Jenkins

## Part 2 - Install Java, Maven and Git packages

- Connect to the Jenkins Server 
  
- Install Java
  
```bash
sudo yum update -y
sudo amazon-linux-extras install java-openjdk11 -y
sudo yum install java-devel 
```

- Install Maven
  
```bash
sudo su
cd /opt
rm -rf maven
wget https://ftp.itu.edu.tr/Mirror/Apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
tar -zxvf $(ls | grep apache-maven-*-bin.tar.gz)
rm -rf $(ls | grep apache-maven-*-bin.tar.gz)
sudo ln -s $(ls | grep apache-maven*) maven
echo 'export M2_HOME=/opt/maven' > /etc/profile.d/maven.sh
echo 'export PATH=${M2_HOME}/bin:${PATH}' >> /etc/profile.d/maven.sh
exit
source /etc/profile.d/maven.sh
```
- Install Git
  
```bash
sudo yum install git -y
```

## Part 3 - Maven Settings

- Open Jenkins GUI on web browser

- Setting System Maven Path for default usage
  
- Go to `Manage Jenkins`
  - Select `Configure System`
  - Find `Environment variables` part,
  - Click `Add`
    - for `Name`, enter `PATH+EXTRA` 
    - for `Value`, enter `/opt/maven/bin`
- Save

- Setting a specific Maven Release in Jenkins for usage
  
- Go to the `Global Tool Configuration`
- To the bottom, `Maven` section
  - Give a name such as `maven-3.6.3`
  - Select `install automatically`
  - `Install from Apache` version `3.6.3`
- Save

# Creating Jobs for Build and Deployment


## Part 4 - Creating a view

- Click `My Views` on the left menu items or click `+` on the jobs tabs.

- Select `New View`

- Give a name like `tomcat-application`

- Select `List View` option

- Select `OK` option

## Part 5 - Creating Package Application - Free Style Maven Job

- Select `New Item`

- Enter name as `Package-Application`

- Select `Free Style Project`

- For Description : `This Job is packaging Java-Tomcat-Sample Project and creates a war file.`

- At `General Tab`, select `Strategy` and for `Days to keep builds` enter `5` and `Max # of builds to keep` enter `1`.

- From `Source Code Management` part select `Git`

- Enter `https://github.com/JBCodeWorld/java-tomcat-sample.git` for `Repository URL`.

- Go to the web browser and check the branch of the git project `https://github.com/JBCodeWorld/java-tomcat-sample.git`. Most of the time, deafult branch is `master` but there may be some exceptions. Enter the brach name (`main`) to the `Branch Specifier (blank for 'any')`. 

- It is public repo, no need for `Credentials`.

- At `Build Environments` section, select `Delete workspace before build starts` and `Add timestamps to the Console Output` options.

- For `Build`, select `Invoke top-level Maven targets`

  - For `Maven Versin`, select the pre-defined maven, `maven-3.6.3` 
  - For `Goals`, write `clean package`
  - POM: `pom.xml`

- At `Post-build Actions` section,
  - Select `Archive the artifacts`
  - For `Files to archive`, write `**/*.war` 

- Finally `Save` the job.

- Go to the `tomcat-application` view.

- Select `Package-Application`

- Click `Build Now` option.

- Observe the Console Output


## Part 6 - Installing Plugins

- Follow `Manage Jenkins` -> `Manage Plugins` path and install the plugins:

  -  `AnsiColor`
    
  -  `Copy Artifact`

  -  `Deploy to container`


## Part 7 - Deploy Application to Staging Environment

- Got to `tomcat-application` view

- Select `New Item`

- Enter name as `Deploy-Application-Staging-Environment`

- Select `Free Style Project`

- For Description : `This Job will deploy a Java-Tomcat-Sample to the staging environment.`

- At `General Tab`, select `Strategy` and for `Days to keep builds` enter `5` and `Max # of builds to keep` enter `1`.

- At `Build Environments` section, select `Delete workspace before build starts` and `Add timestamps to the Console Output` options.

- For `Build`, select `Copy artifact from another project`

  - Select `Project name` as `Package-Application`
  - Select `Latest successful build` for `Which build`
  - Check `Stable build only`
  - For `Artifact to copy`, fill in `**/*.war`

- For `Add post-build action`, select `Deploy war/ear to a container`
  - for `WAR/EAR files`, fill in `**/*.war`.
  - for `Context path`, filll in `/`.
  - for `Containers`, select `Tomcat 8.x Remote`.
  - Add credentials
    - Add -> Jenkins
      - Add `username` and `password` as `tomcat/tomcat`.
    - From `Credentials`, select `tomcat/*****`.
  - for `Tomcat URL`, select `private ip` of staging tomcat server like `http://172.31.20.75:8080`.

- Click on `Save`.

- Go to the `Deploy-Application-Staging-Environment` 

- Click `Build Now`.

- Explain the built results.

- Open the staging server url with port # `8080` and check the results.

## Part 8 - Update the application and deploy to the staging environment

-  Go to the `Package-Application`
   -  Select `Configure`
   -  Select the `Post-build Actions` tab
   -  From `Add post-build action`, `Build othe projects`
      -  For `Projects to build`, fill in `Deploy-Application-Staging-Environment`
      -  And select `Trigger only if build is stable` option.
   - Go to the `Build Triggers` tab
     - Select `Poll SCM`
       - In `Schedule`, fill in `* * * * *` (5 stars)
         - You will see the warning `Do you really mean "every minute" when you say "* * * * *"? Perhaps you meant "H * * * *" to poll once per hour`
  
   - `Save` the modified job.

   - At `Project Package-Application`  page, you will see `Downstream Projects` : `Deploy-Application-Staging-Environment`


- Update the web site content, and commit to the GitHub.

- Go to the  `Project Package-Application` and `Deploy-Application-Staging-Environment` pages and observe the auto build & deploy process.

- Explain the built results.

- Open the staging server url with port # `8080` and check the results.

## Part 9 - Build Pipeline Plugin

- Go to the `Manage Jenkins`

- Select `Manage Plugins`

- Select `Available` tab

- Look for the `Build Pipeline` plugin

- If not installed, install `Build Pipeline` plugin with `Install without restart` option.

- Now, go to the dashboard and click `+` to add a new `View`
  - for `View name`, fill in `Pipeline-Tomcat-View`
  - Select the `Build Pipeline View`
  - Click `OK`
  
- for `Build Pipeline View Title`, enter `Deploy-Application-Staging-Environment` 
  
- for `Pipeline Flow: Layout`, select `Based on upstreram/downstream relationship`
  
- for `Select Initial Job`, select `Package-Application` job.
  
- Select `OK`.
  
- You will `Build Pipeline: Deploy-Application-Staging-Environment` with a pretty grahical presentation.
  
- Press the `Run`, and observe the behavior. Click the `Refresh` button of the browser.
  
- Explain the `console` and `re-run` buttons at the right bottom corner of the jobs.


## Part 10 - Deploy application to production environment

- Go to the dashboard

- Select `tomcat-application` view.

- Select `New Item`

- Enter name as `Deploy-Application-Production-Environment`

- Select `Free Style Project`

- For Description : `This Job will deploy a Java-Tomcat-Sample to the deployment environment.`

- At `General Tab`, select `Strategy` and for `Days to keep builds` enter `5` and `Max # of builds to keep` enter `1`.

- At `Build Environments` section, select `Delete workspace before build starts` and `Add timestamps to the Console Output` options.

- For `Build`, select `Copy artifact from another project`

  - Select `Project name` as `Package-Application`
  - Select `Latest successful build` for `Which build`
  - Check `Stable build only`
  - For `Artifact to copy`, fill in `**/*.war`

- For `Add post-build action`, select `Deploy war/ear to a container`
  - for `WAR/EAR files`, fill in `**/*.war`.
  - for `Context path`, filll in `/`.
  - for `Containers`, select `Tomcat 8.x Remote`.
  - From `Credentials`, select `tomcat/*****`.
  - for `Tomcat URL`, select `private ip` of production tomcat server like `http://172.31.28.5:8080`.

- Click on `Save`.

- Now add this job to the pipeline

- Go to the `Deploy-Application-Staging-Environment` page

- Select `Configure`

- Go to the `Post-build Actions`

- Select `Build other projects (manual step)` from `Add post-build action`

- for `Downstream Project Names`, select  `Deploy-Application-Production-Environment`

- `Save` and `Refresh` the page and observe

  - Upstream Projects : Package-Application
  - Downstream Projects :Deploy-Application-Production-Environment

- Got to the `Pipeline-Tomcat-View` and observe the pipeline (`Deploy-Application-Production-Environment` added to the pipeline).

# Job DSL

## Part 11 - Jenkins Job DSL

- Install `Job DSL` plugin

- Go to the dashboard and create a `Seed Job` in form of `Free Style Project`. To do so;

- Click on `New Item`

  - Enter name as `Maven-Seed-Job`

  - Select `Freestyle project`

  - Click `OK`

- Inside `Source Code Management` tab

  - Select `Git`
  
  - Select the path to download the DSL file, so for `Repository URL`, enter `https://github.com/JBCodeWorld/jenkins-project-settings.git`

- Inside `Build Options` tab

  - From `Add build step`, select the `Process Job DSLs`.

  - for `DSL Scripts`, enter `MavenProjectDSL.groovy`
  
- Now click the  `Build Now` option, it will fail. Chect the console log for the fail reason.

- Go to `Manage Jenkins` ,  select the `In-process Script Approval`, `approve` the script.
  
- Go to the job and click the  `Build Now` again.

- Observe that DSL Job created.

- Go to the `First-Maven-Project-Via-DSL` job.

- Select `Configure`, at `Buld` section set `Maven Version` to a defined/valid one.

- `Save` and click the `Build Now` option.

- Ckeck the console log

- Back to the job tab and show the `Last Successful Artifacts : single-module-project.jar`


# Pipeline

## Part 12 - Creating a Pipeline with Jenkins

- Go to the Jenkins dashboard and click on `New Item` to create a pipeline.

- Enter `sample-code-pipeline` then select `Pipeline` and click `OK`.

- Enter `This is a sample code pipeline project` in the description field.

- Go to the `Pipeline` section, enter following script, then click `apply` and `save`.

- Chect that `Pipeline script` option is selected.

```text
pipeline {
      agent any
      stages {
            stage('Init') {
                  steps {
                        echo 'Hi Clarusway trainees...!'
                        echo 'We are Starting the Testing'
                  }
            }
            stage('Build') {
                  steps {
                        echo 'Building Sample Maven Project'
                  }
            }
            stage('Deploy Staging') {
                  steps {
                        echo "Deploying to Staging Area"
                  }
            }
      }
}
```
- `Save` the job

- Go to the dashboard and observe that `sample-code-pipeline` is created.

- Select this job and click `Build Now` option.

- Observe the console and job dashboard.

- modify the script and observe the behaviour, to do so, add another stage to the end of the stages:

```text
            stage('Deploy Production') {
                  steps {
                        echo "Deploying to Production Area"
                  }
            }
```

- Now go to the `Configure` and skip to the `Pipeline` section
  - for definition, select `Pipeline script from SCM`
  - for SCM, select `Git`
    - for `Repository URL`, select `https://github.com/JBCodeWorld/jenkins-project-settings.git`, show the `Jenkinsfile` here.
    - approve that the `Script Path` is `Jenkinsfile`
- `Save` and `Build Now` and observe the behavior.

- Go to the the `Configure` and skip to the `Build Triggers` section
  - Select Poll SCM, and enter `* * * * *` (5 stars)
- `Save` the configuration.

- Got to the GitHub repo and modify some part in the `Jenkinsfile` and commit.

- Observe the auto build action at Jenkins job.


## Part 13 - Automate Existing Maven Project as Pipeline with Jenkins

- Go to the Jenkins dashboard and click on `New Item` to create a pipeline.

- Enter `package-application-code-pipeline` then select `Pipeline` and click `OK`.

- Enter `This code pipeline Job is to package the maven project` in the description field.

- At `General Tab`, select `Discard old build`,
  -  select `Strategy` and 
     -  for `Days to keep builds` enter `5` and 
     -  `Max # of builds to keep` enter `1`.

- At `Advanced Project Options: Pipeline` section

  - for definition, select `Pipeline script from SCM`
  - for SCM, select `Git`
    - for `Repository URL`, select `https://github.com/JBCodeWorld/java-tomcat-sample.git`, show the `Jenkinsfile` here.
    - for `Branch Specifier`, enter `*/main` as the GitHub branch is like that.
    - approve that the `Script Path` is `Jenkinsfile`
- `Save` and `Build Now` and observe the behavior.



- Copy the existing 2 jobs ( `Deploy-Application-Staging-Environment` , `Deploy-Application-Production-Environment` ) and modify them for pipeline.

- Go to dashbord click on `New Item` to copy `Deploy-Application-Staging-Environment`

- For name, enter `deploy-application-staging-environment-pipeline`

- At the bottom, `Copy from`, enter `Deploy-Application-Staging-Environment`

- Click `OK`, and `Save`



- Go to dashbord click on `New Item` to copy `Deploy-Application-Production-Environment`

- For name, enter `deploy-application-production-environment-pipeline`

- At the bottom, `Copy from`, enter `Deploy-Application-Production-Environment`

- Click `OK`, and `Save`


- Go to the `deploy-application-staging-environment-pipeline` job

- Find the `Build` section,
  - for `Project name`, enter `package-application-code-pipeline` 
  - select `Last successful build`

- At `Post-build Actions (manual steps)`, click the `X` to remove this section.

- `Save` the job


- Go to the `deploy-application-production-environment-pipeline` job

- Find the `Build` section,
  - for `Project name`, enter `package-application-code-pipeline` 
  - select `Last successful build`

- `Save` the job

- Now, update the `Jenkinsfile` to include last 2 stages. For this purpose, add these 2 stages in `Jenkinsfile` like below:

```text
        stage('Deploy to Staging Environment'){
            steps{
                build job: 'deploy-application-staging-environment-pipeline'

            }
            
        }
        stage('Deploy to Production Environment'){
            steps{
                timeout(time:5, unit:'DAYS'){
                    input message:'Approve PRODUCTION Deployment?'
                }
                build job: 'deploy-application-production-environment-pipeline'
            }
        }
```

- Note: You can also use updated `Jenkinsfile2` file instead of updating `Jenkinsfile`.

- Go to the `package-application-code-pipeline` then select `Build Now` and observe the behaviors.




