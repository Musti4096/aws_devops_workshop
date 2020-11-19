# Hands-on Jenkins-01 : Installing Jenkins on Amazon Linux 2 EC2 Instance

Purpose of the this hands-on training is to learn how to install Jenkins Server on Amazon Linux 2 EC2 instance with three different ways.

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- install and configure Jenkins Server on Amazon Linux 2 EC2 instance using `yum` repo.

- install and configure Jenkins Server on Amazon Linux 2 EC2 instance using Docker.

- install and configure Jenkins Server on Amazon Linux 2 EC2 instance using `war` file.

- install and configure Jenkins Server on Amazon Linux 2 EC2 instance using Docker and Docker Compose.


## Outline

- Part 1 - Installing Jenkins Server on Amazon Linux 2 with `yum` Repo

- Part 2 - Installing Jenkins Server on Amazon Linux 2 Docker

- Part 3 - Installing Jenkins Server on Amazon Linux 2 with `war` File

- Part 4 - Installing Jenkins Server on Amazon Linux 2 with Docker and Docker Compose

## Part 1 - Installing Jenkins Server on Amazon Linux 2 with `yum` Repo

- Launch an AWS EC2 instance of Amazon Linux 2 AMI with security group allowing SSH and Tomcat (8080) ports and name it as `call-jenkins`.

- Connect to the `call-jenkins` instance with SSH.

```bash
ssh -i .ssh/call-training.pem ec2-user@ec2-3-133-106-98.us-east-2.compute.amazonaws.com
```

- Update the installed packages and package cache on your instance.

```bash
sudo yum update -y
```

- Install `Java 11 openjdk` Java Development Kit.

```bash
sudo amazon-linux-extras install java-openjdk11 -y
```

- Check the java version.

```bash
java -version
```

- Add Jenkins repo to the `yum` repository.

```bash
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
```

- Import a key file from Jenkins-CI to enable installation from the package.

```bash
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
```

- Install Jenkins.

```bash
sudo yum install jenkins -y
```

- Start Jenkins service.

```bash
sudo systemctl start jenkins
```

- Enable Jenkins service so that Jenkins service can restart automatically after reboots.

```bash
sudo systemctl enable jenkins
```

- Check if the Jenkins service is up and running.

```bash
sudo systemctl status jenkins
```

- Get the initial administrative password.

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

- Enter the temporary password to unlock the Jenkins.

- Install suggested plugins.

- Create first admin user (call-jenkins:Call-jenkins1234).

- Check the URL, then save and finish the installation.

## Part 2 - Installing Jenkins Server on Amazon Linux 2 with Docker

- Launch an AWS EC2 instance of Amazon Linux 2 AMI with security group allowing SSH and Tomcat (8080) ports and name it as `call-jenkins`.

- Connect to the `call-jenkins` instance with SSH.

```bash
ssh -i .ssh/call-training.pem ec2-user@ec2-3-133-106-98.us-east-2.compute.amazonaws.com
```

- Update the installed packages and package cache on your instance.

```bash
sudo yum update -y
```

- Install the most recent Docker Community Edition package.

```bash
sudo amazon-linux-extras install docker -y
```

- Start Docker service.

```bash
sudo systemctl start docker
```

- Enable Docker service so that docker service can restart automatically after reboots.

```bash
sudo systemctl enable docker
```

- Check if the Docker service is up and running.

```bash
sudo systemctl status docker
```

- Add the `ec2-user` to the `docker` group to run Docker commands without using `sudo`.

```bash
sudo usermod -a -G docker ec2-user
```

- Normally, the user needs to re-login into bash shell for the group `docker` to be effective, but `newgrp` command can be used activate `docker` group for `ec2-user`, not to re-login into bash shell.

```bash
newgrp docker
```

- Check the Docker version without `sudo`.

```bash
docker version
```

- Run Docker Jenkins image from Docker Hub `Jenkins` repo.

```bash
docker run \
  -u root \
  --rm \
  -d \
  -p 8080:8080 \
  -p 50000:50000 \
  --name jenkins \
  -v jenkins-data:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkins/jenkins:lts
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

## Part 3 - Installing Jenkins Server on Amazon Linux 2 with `war` File

- Launch an AWS EC2 instance of Amazon Linux 2 AMI with security group allowing SSH and Tomcat (8080) ports and name it as `call-jenkins`.

- Connect to the `call-jenkins` instance with SSH.

```bash
ssh -i .ssh/call-training.pem ec2-user@ec2-3-133-106-98.us-east-2.compute.amazonaws.com
```

- Update the installed packages and package cache on your instance.

```bash
sudo yum update -y
```

- Install `Java 11 openjdk` Java Development Kit.

```bash
sudo amazon-linux-extras install java-openjdk11 -y
```

- Check the java version.

```bash
java -version
```

- Download Jenkins application.

```bash
wget http://mirrors.jenkins.io/war-stable/latest/jenkins.war
```

- Start Jenkins application.

```bash
java -jar jenkins.war --httpPort=8080
```

- Copy the admin password from log or from the file `~/.jenkins/secrets/initialAdminPassword`.

```bash
cat ~/.jenkins/secrets/initialAdminPassword
```

- Open Jenkins initial setup page from web browser using the Public DNS name of the `call-jenkins` instance using port 8080.

- Enter the temporary password to unlock the Jenkins.

- Install suggested plugins.

- Create first admin user (call-jenkins:Call-jenkins1234).

- Check the URL, then save and finish the installation.


## Part 4 - Installing Jenkins Server on Amazon Linux 2 with Docker and Docker Compose

- Launch an AWS EC2 instance of Amazon Linux 2 AMI with security group allowing SSH and Tomcat (8080) ports and name it as `call-jenkins`.

- Connect to the `call-jenkins` instance with SSH.

```bash
ssh -i .ssh/call-training.pem ec2-user@ec2-3-133-106-98.us-east-2.compute.amazonaws.com
```

- Update the installed packages and package cache on your instance.

```bash
sudo yum update -y
```

- Install the most recent Docker Community Edition package.

```bash
sudo amazon-linux-extras install docker -y
```

- Start Docker service.

```bash
sudo systemctl start docker
```

- Enable Docker service so that docker service can restart automatically after reboots.

```bash
sudo systemctl enable docker
```

- Check if the Docker service is up and running.

```bash
sudo systemctl status docker
```

- Add the `ec2-user` to the `docker` group to run Docker commands without using `sudo`.

```bash
sudo usermod -a -G docker ec2-user
```

- Normally, the user needs to re-login into bash shell for the group `docker` to be effective, but `newgrp` command can be used activate `docker` group for `ec2-user`, not to re-login into bash shell.

```bash
newgrp docker
```


- Check the Docker version without `sudo`.

```bash
docker version
```


- Install `docker-compose`

```bash
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose
```

- Make a directory for `docker-compose.yaml`

```bash
mkdir jenkins
cd jenkins

mkdir  jenkins_home
sudo chmod 777 jenkins_home
```

- Create a file named as `docker-compose.yaml` and add this content.

```bash
version: '3'
services:
  jenkins:
    container_name: jenkins
    build: .
    ports:
      - "8080:8080"
    volumes:
      - $PWD/jenkins_home:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
```

- Create a file named as `Dockerfile` and add this content.

```bash
FROM jenkins/jenkins
USER root
RUN apt-get update && apt-get install python3-pip -y && \
    pip3 install ansible --upgrade
USER jenkins
```

- Exectue the following command.

```bash
docker-compose up -d
```

- The administrator password can also be taken from Docker logs.
```bash
docker logs jenkins
```

- Enter the temporary password to unlock the Jenkins.

- Install suggested plugins.

- Create first admin user (call-jenkins:Call-jenkins1234).

- Check the URL, then save and finish the installation.
