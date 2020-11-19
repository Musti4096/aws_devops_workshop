# Hands-on Jenkins-02 : Building Jenkins Job on Amazon Linux 2 AWS EC2 Instance

Purpose of the this hands-on training is to teach the students how to build Jenkins jobs on Amazon Linux 2 EC2 instance.

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- install Jenkins Server on Docker on Amazon Linux 2 EC2 instance using Cloudformation Service.

- explain Jenkins dashboard and get familiar with menus.

- build simple Jenkins Job.

## Outline

- Part 1 - Install Jenkins on Docker using Cloudformation Template

- Part 2 - Install Jenkins Natively using Cloudformation Template

- Part 3 - Getting familiar with Jenkins Dashboard

- Part 4 - Creating First Jenkins Job

## Part 1 - Install Jenkins on Docker using Cloudformation Template

- Launch a Jenkins Server on Amazon Linux 2 AMI with security group allowing SSH (port 22) and HTTP (ports 80, 8080) connections using the [Cloudformation Template for Jenkins on Docker Installation](./jenkins-on-docker-cfn-template.yml).

- Connect to your instance with SSH.

```bash
ssh -i .ssh/call-training.pem ec2-user@ec2-3-133-106-98.us-east-2.compute.amazonaws.com
```

- Get the administrator password from `/var/jenkins_home/secrets/initialAdminPassword` file.

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

- Create first admin user (call-jenkins:Call-jenkins1234).

- Check the URL, then save and finish the installation.

## Part 2 - Install Jenkins Natively using Cloudformation Template

- Launch and configure a Jenkins Server on Amazon Linux 2 AMI with security group allowing SSH (port 22) and HTTP (ports 80, 8080) connections using the [Cloudformation Template for Jenkins Native Installation](./jenkins-native-install-cfn-template.yml).

- Connect to your instance with SSH.

```bash
ssh -i .ssh/call-training.pem ec2-user@ec2-3-133-106-98.us-east-2.compute.amazonaws.com
```

- Get the administrator password from `/var/lib/jenkins/secrets/initialAdminPassword` file with `sudo cat /var/lib/jenkins/secrets/initialAdminPassword`

- Enter the temporary password to unlock the Jenkins.

- Install suggested plugins.

- Create first admin user (call-jenkins:Call-jenkins1234).

- Check the URL, then save and finish the installation.
## Part 3 - Getting familiar with Jenkins Dashboard

- Explain `Jenkins` dashboard.

- Explain `Items` options.

- Explain `Manage Jenkins` dashboard.

- Explain other Jenkins terminology.

## Part 4 - Creating First Jenkins Job

- We will create a job in Jenkins which picks up a simple "Hello World" bash script and runs it. The freestyle build job is a highly flexible and easy-to-use option. To create a Jenkins freestyle job;

  - Login to Jenkins Server if you haven't so far;

    - Open Jenkins Server which is hosted on on **`http://[ec2-public-dns-name]:8080`**.

    - Log in to Jenkins with username and password.

  - Open your Jenkins dashboard and click on `New Item` to create a new job item.

  - Enter `my first job` then select `free style project` and click `OK`.

  - Enter `My first jenkins job with python` in the description field.

  - Explain `Source Code Management`, `Build Triggers`,  `Build Environment`, `Build`, `Post-build Actions` tabs.

    ```text
    1. Source Code Management Tab : optional SCM, such as CVS or Subversion where your source code resides.
    2. Build Triggers : Optional triggers to control when Jenkins will perform builds.
    3. Build Environment: Some sort of build script that performs the build 
    (ant, maven, shell script, batch file, etc.) where the real work happens
    4. Build : Optional steps to collect information out of the build, 
    such as archiving the artifacts and/or recording javadoc and test results.
    5. Post-build Actions : Optional steps to notify other people/systems 
    with the build result, such as sending e-mails, IMs, updating issue tracker, etc.
    ```

  - Go to `Build` section and choose appropriate build step from `Add build step` dropdown menu.

  - Write down just ``echo "Hello World, This is my first job"` to execute shell command, in textarea shown.

  - Click `apply` and `save`  buttons.

- On the Project job page, click to `Build now`.

- Show and explain the result of this build action under the `Build History`

  - Click to the build number to reach build page.

  - Show the console results from `Console Output`.
