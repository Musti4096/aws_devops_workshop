# Project 501: Microservices CI/CD Pipeline

## Description

This project aims to create full CI/CD Pipeline for microservice based applications using [Spring Petclinic Microservices Application](https://github.com/spring-petclinic/spring-petclinic-microservices). Jenkins Server deployed on Elastic Compute Cloud (EC2) Instance is used as CI/CD Server to build pipelines.

## DevOps Pipelines

### Development Diagram

![Development Diagram](./project-501-dev-diagram.png)

### Pipelines Configurations

![Pipelines to be configured](./project-501-pipelines.png)

## Flow of Tasks for Project Realization

| Epic | Task  | Task #  | Task Definition   | Branch  |
| ---   | :---  | ---                  | :---              | :---    |
| Local Development Environment | Prepare Development Server Manually on EC2 Instance| MSP-1 | Prepare development server manually on Amazon Linux 2 for developers, enabled with `Docker` , `Docker-Compose` , `Java 11` , `Git` .  |
| Local Development Environment | Prepare GitHub Repository for the Project | MSP-2-1 | Clone the Petclinic app from the Clarusway repository [Petclinic Microservices Application](https://github.com/clarusway/petclinic-microservices.git) |
| Local Development Environment | Prepare GitHub Repository for the Project | MSP-2-2 | Prepare base branches namely `master` , `dev` , `release` for DevOps cycle. |
| Local Development Environment | Check the Maven Build Setup on Dev Branch | MSP-3 | Check the Maven builds for `test` , `package` , and `install` phases on `dev` branch |
| Local Development Environment | Prepare a Script for Packaging the Application | MSP-4 |  Prepare a script to package the application with Maven wrapper | feature/msp-4 |
| Local Development Environment | Prepare Development Server Cloudformation Template | MSP-5 |  Prepare development server script with Cloudformation template for developers, enabled with `Docker` , `Docker-Compose` , `Java 11` , `Git` . | feature/msp-5 |
| Local Development Build | Prepare Dockerfiles for Microservices | MSP-6 | | Prepare Dockerfiles for each microservices. | feature/msp-6 |
| Local Development Environment | Prepare Script for Building Docker Images | MSP-7 |  Prepare a script to package and build the docker images for all microservices. | feature/msp-7 |
| Local Development Build | Create Docker Compose File for Local Development | MSP-8-1 |  Prepare docker compose file to deploy the application locally. | feature/msp-8 |
| Local Development Build | Create Docker Compose File for Local Development | MSP-8-2 |  Prepare a script to test the deployment of the app locally. | feature/msp-8 |
| Testing Environment Setup | Implement Unit Tests | MSP-9-1  | Implement 3 Unit Tests locally. | feature/msp-9 |
| Testing Environment Setup | Setup Code Coverage Tool | MSP-9-2  | Update POM file for Code Coverage Report. | feature/msp-9 |
| Testing Environment Setup | Implement Code Coverage | MSP-9-3  | Generate Code Coverage Report manually. | feature/msp-9 |
| Testing Environment Setup | Prepare Selenium Tests | MSP-10-1  | Prepare 3 Selenium Jobs for QA Automation Tests. | feature/msp-10 |
| Testing Environment Setup | Implement Selenium Tests | MSP-10-2  | Run 3 Selenium Tests against local environment. | feature/msp-10 |
| CI Server Setup | Prepare Jenkins Server | MSP-11 | | Prepare Jenkins Server for CI/CD Pipeline. | feature/msp-11 |
| CI Server Setup | Configure Jenkins Server for Project | MSP-12  | Configure Jenkins Server for Project Setup. | |
| CI Server Setup | Prepare CI Pipeline | MSP-13 | | Prepare CI pipeline (UT only) for all `dev` , `feature` and `bugfix` branches. | feature/msp-13 |
| Registry Setup for Development | Create Docker Registry for Dev Manually | MSP-14  | Create Docker Registry on AWS ECR manually using Jenkins job. | |
| Registry Setup for Development | Prepare Script for Docker Registry| MSP-15  | Prepare a script to create Docker Registry on AWS ECR using Jenkins job. | feature/msp-15 |
| QA Automation Setup for Development | Create a QA Automation Environment | MSP-16  | Create a QA Automation Environment with Docker Swarm. | feature/msp-16 |
| QA Automation Setup for Development | Prepare a QA Automation Pipeline | MSP-17  | Prepare a QA Automation Pipeline on `dev` branch for Nightly Builds. | feature/msp-17 |
| QA Setup for Release | Create a Key Pair for QA Environment | MSP-18-1  | Create a permanent Key Pair for Ansible to be used in QA Environment on Release. | feature/msp-18 |
| QA Setup for Release | Create a QA Infrastructure with AWS Cloudformation | MSP-18-2  | Create a Permanent QA Infrastructure for Docker Swarm with AWS Cloudformation. | feature/msp-18 |
| QA Setup for Release | Create a QA Environment with Docker Swarm | MSP-18-3  | Create a QA Environment for Release with Docker Swarm. | feature/msp-18 |
| QA Setup for Release | Prepare Build Scripts for QA Environment | MSP-19  | Prepare Build Scripts for creating ECR Repo for QA, building QA Docker images, deploying app with Docker Compose. | feature/msp-19 |
| QA Setup for Release | Build and Deploy App on QA Environment Manually | MSP-20  | Build and Deploy App for QA Environment Manually using Jenkins Jobs. | feature/msp-20 | 
| QA Setup for Release | Prepare a QA Pipeline | MSP-21  | Prepare a QA Pipeline using Jenkins on `release` branch for Weekly Builds. | feature/msp-21 |
| Staging and Production Setup | Prepare Petlinic Kubernetes YAML Files | MSP-22  | Prepare Petlinic Kubernetes YAML Files for Staging and Production Pipelines. | feature/msp-22 |
| Staging and Production Setup | Prepare HA RKE Kubernetes Cluster | MSP-23  | Prepare High-availability RKE Kubernetes Cluster on AWS EC2 | feature/msp-23 |
| Staging and Production Setup | Install Rancher App on RKE K8s Cluster | MSP-24  | Install Rancher App on RKE Kubernetes Cluster| |
| Staging and Production Setup | Create Staging and Production Environment with Rancher | MSP-25  | Create Staging and Production Environment with Rancher by creating new cluster for Petclinic | |
| Staging Deployment Setup | Prepare a Staging Pipeline | MSP-26  | Prepare a Staging Pipeline on Jenkins Server | feature/msp-26|
| Production Deployment Setup | Prepare a Production Pipeline | MSP-27  | Prepare a Production Pipeline on Jenkins Server | feature/msp-27|
| Production Deployment Setup | Set Domain Name and TLS for Production | MSP-28  | Set Domain Name and TLS for Production Pipeline with Route 53 | feature/msp-28|
| Production Deployment Setup | Set Monitoring Tools | MSP-29  | Set Monitoring tools, Prometheus and Grafana | |

## MSP 1 - Prepare Development Server Manually on EC2 Instance

* Prepare development server manually on Amazon Linux 2 for developers, enabled with `Docker`,  `Docker-Compose`,  `Java 11`,  `Git`.

``` bash
#! /bin/bash
yum update -y
hostnamectl set-hostname petclinic-dev-server
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
usermod -a -G docker ec2-user
curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" \
-o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
yum install git -y
yum install java-11-amazon-corretto -y
```

## MSP 2 - Prepare GitHub Repository for the Project

* Clone the petclinic app from the repository [Spring Petclinic Microservices App](https://github.com/clarusway/petclinic-microservices.git) on your local machine

``` bash
git clone https://github.com/clarusway/petclinic-microservices.git
```

* Change your working directory to **petclinic-microservices** and delete the **.git** directory.

```bash
cd petclinic-microservices
rm -rf .git
```

* Create a new repository on your Github with the name **petclinic-microservices**.

*  Initiate the cloned repository on your local machine to make it a git repository and push the local repository to your remote repository.

```bash
git init
git add .
git commit -m "first commit"
git remote add origin https://github.com/[your-git-account]/petclinic-microservices.git
git push origin main
```

* Clone the petclinic-microservices repo from your GitHub repo on development server.

``` bash
git clone https://github.com/clarusway/petclinic-microservices.git
```

* Prepare base branches namely `master`,  `dev`,  `release` for DevOps cycle.

  + Create `dev` base branch.

    ``` bash
    git checkout master
    git branch dev
    git checkout dev
    git push --set-upstream origin dev
    ```

  + Create `release` base branch.

    ```bash
    git checkout master
    git branch release
    git checkout release
    git push --set-upstream origin release
    ```

## MSP 3 - Check the Maven Build Setup on Dev Branch

* Switch to `dev` branch.

``` bash
git checkout dev
```

* Test the compiled source code.

``` bash
./mvnw clean test
```
> Note: If you get `permission denied` error, try to give execution permission to **mvnw**.  

    chmod +x mvnw
  

* Take the compiled code and package it in its distributable `JAR` format.

``` bash
./mvnw clean package
```

* Install distributable `JAR`s into local repository.

``` bash
./mvnw clean install
```

## MSP 4 - Prepare a Script for Packaging the Application

* Create `feature/msp-4` branch from `dev`.

``` bash
git checkout dev
git branch feature/msp-4
git checkout feature/msp-4
```

* Prepare a script to package the application with maven wrapper and save it as `package-with-mvn-wrapper.sh`.

``` bash
./mvnw clean package
```

* Commit and push the new script to remote repo.

``` bash
git add .
git commit -m 'added packaging script'
git push --set-upstream origin feature/msp-4
git checkout dev
git merge feature/msp-4
git push origin dev
```

## MSP 5 - Prepare Development Server Cloudformation Template

* Create `feature/msp-5` branch from `dev`.

``` bash
git checkout dev
git branch feature/msp-5
git checkout feature/msp-5
```

* Create a folder for infrastructure setup with the name of `infrastructure`.

``` bash
mkdir infrastructure
```

* Prepare development server script with [Cloudformation template](./msp-5-dev-server-for-petclinic-app-cfn-template.yml) for developers, enabled with `Docker`,  `Docker-Compose`,  `Java 11`,  `Git` and save it as `dev-server-for-petclinic-app-cfn-template.yml` under `infrastructure` folder.

``` bash
#! /bin/bash
yum update -y
hostnamectl set-hostname petclinic-dev-server
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
usermod -a -G docker ec2-user
curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" \
-o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
yum install git -y
yum install java-11-amazon-corretto -y
git clone https://github.com/clarusway/petclinic-microservices.git
git fetch
git checkout dev
```

* Commit and push the new script to remote repo.

``` bash
git add .
git commit -m 'added cloudformation template for dev server'
git push --set-upstream origin feature/msp-5
git checkout dev
git merge feature/msp-5
git push origin dev
```

## MSP 6 - Prepare Dockerfiles for Microservices

* Create `feature/msp-6` branch from `dev`.

``` bash
git checkout dev
git branch feature/msp-6
git checkout feature/msp-6
```

* Prepare a Dockerfile for the `admin-server` microservice with following content and save it under `spring-petclinic-admin-server`.

``` Dockerfile
FROM openjdk:11-jre
ARG DOCKERIZE_VERSION=v0.6.1
ARG EXPOSED_PORT=9090
ENV SPRING_PROFILES_ACTIVE docker
ADD https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_VERSION}/dockerize-alpine-linux-amd64-${DOCKERIZE_VERSION}.tar.gz dockerize.tar.gz
RUN tar xzf dockerize.tar.gz
RUN chmod +x dockerize
ADD ./target/*.jar /app.jar
EXPOSE ${EXPOSED_PORT}
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]
```

* Prepare a Dockerfile for the `api-gateway` microservice with the following content and save it under `spring-petclinic-api-gateway`.

``` Dockerfile
FROM openjdk:11-jre
ARG DOCKERIZE_VERSION=v0.6.1
ARG EXPOSED_PORT=8080
ENV SPRING_PROFILES_ACTIVE docker
ADD https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_VERSION}/dockerize-alpine-linux-amd64-${DOCKERIZE_VERSION}.tar.gz dockerize.tar.gz
RUN tar xzf dockerize.tar.gz
RUN chmod +x dockerize
ADD ./target/*.jar /app.jar
EXPOSE ${EXPOSED_PORT}
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]
```

* Prepare a Dockerfile for the `config-server` microservice with the following content and save it under `spring-petclinic-config-server`.

``` Dockerfile
FROM openjdk:11-jre
ARG DOCKERIZE_VERSION=v0.6.1
ARG EXPOSED_PORT=8888
ENV SPRING_PROFILES_ACTIVE docker
ADD https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_VERSION}/dockerize-alpine-linux-amd64-${DOCKERIZE_VERSION}.tar.gz dockerize.tar.gz
RUN tar xzf dockerize.tar.gz
RUN chmod +x dockerize
ADD ./target/*.jar /app.jar
EXPOSE ${EXPOSED_PORT}
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]
```

* Prepare a Dockerfile for the `customer-service` microservice with the following content and save it under `spring-petclinic-customer-service`.

``` Dockerfile
FROM openjdk:11-jre
ARG DOCKERIZE_VERSION=v0.6.1
ARG EXPOSED_PORT=8081
ENV SPRING_PROFILES_ACTIVE docker
ADD https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_VERSION}/dockerize-alpine-linux-amd64-${DOCKERIZE_VERSION}.tar.gz dockerize.tar.gz
RUN tar xzf dockerize.tar.gz
RUN chmod +x dockerize
ADD ./target/*.jar /app.jar
EXPOSE ${EXPOSED_PORT}
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]
```

* Prepare a Dockerfile for the `discovery-server` microservice with the following content and save it under `spring-petclinic-discovery-server`.

``` Dockerfile
FROM openjdk:11-jre
ARG DOCKERIZE_VERSION=v0.6.1
ARG EXPOSED_PORT=8761
ENV SPRING_PROFILES_ACTIVE docker
ADD https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_VERSION}/dockerize-alpine-linux-amd64-${DOCKERIZE_VERSION}.tar.gz dockerize.tar.gz
RUN tar xzf dockerize.tar.gz
RUN chmod +x dockerize
ADD ./target/*.jar /app.jar
EXPOSE ${EXPOSED_PORT}
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]
```

* Prepare a Dockerfile for the `hystrix-dashboard` microservice with the following content and save it under `spring-petclinic-hystrix-dashboard`.

``` Dockerfile
FROM openjdk:11-jre
ARG DOCKERIZE_VERSION=v0.6.1
ARG EXPOSED_PORT=7979
ENV SPRING_PROFILES_ACTIVE docker
ADD https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_VERSION}/dockerize-alpine-linux-amd64-${DOCKERIZE_VERSION}.tar.gz dockerize.tar.gz
RUN tar xzf dockerize.tar.gz
RUN chmod +x dockerize
ADD ./target/*.jar /app.jar
EXPOSE ${EXPOSED_PORT}
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]
```

* Prepare a Dockerfile for the `vets-service` microservice with the following content and save it under `spring-petclinic-vets-service`.

``` Dockerfile
FROM openjdk:11-jre
ARG DOCKERIZE_VERSION=v0.6.1
ARG EXPOSED_PORT=8083
ENV SPRING_PROFILES_ACTIVE docker
ADD https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_VERSION}/dockerize-alpine-linux-amd64-${DOCKERIZE_VERSION}.tar.gz dockerize.tar.gz
RUN tar xzf dockerize.tar.gz
RUN chmod +x dockerize
ADD ./target/*.jar /app.jar
EXPOSE ${EXPOSED_PORT}
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]
```

* Prepare a Dockerfile for the `visits-service` microservice with the following content and save it under `spring-petclinic-visits-service`.

``` Dockerfile
FROM openjdk:11-jre
ARG DOCKERIZE_VERSION=v0.6.1
ARG EXPOSED_PORT=8082
ENV SPRING_PROFILES_ACTIVE docker
ADD https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_VERSION}/dockerize-alpine-linux-amd64-${DOCKERIZE_VERSION}.tar.gz dockerize.tar.gz
RUN tar xzf dockerize.tar.gz
RUN chmod +x dockerize
ADD ./target/*.jar /app.jar
EXPOSE ${EXPOSED_PORT}
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]
```

* Commit the changes, then push the Dockerfiles to the remote repo.

``` bash
git add .
git commit -m 'added Dockerfiles for microservices'
git push --set-upstream origin feature/msp-6
git checkout dev
git merge feature/msp-6
git push origin dev
```

## MSP 7 - Prepare Script for Building Docker Images

* Create `feature/msp-7` branch from `dev`.

``` bash
git checkout dev
git branch feature/msp-7
git checkout feature/msp-7
```

* Prepare a script to build the docker images and save it as `build-dev-docker-images.sh`.

``` bash
./mvnw clean package
docker build --force-rm -t "petclinic-admin-server:dev" ./spring-petclinic-admin-server
docker build --force-rm -t "petclinic-api-gateway:dev" ./spring-petclinic-api-gateway
docker build --force-rm -t "petclinic-config-server:dev" ./spring-petclinic-config-server
docker build --force-rm -t "petclinic-customers-service:dev" ./spring-petclinic-customers-service
docker build --force-rm -t "petclinic-discovery-server:dev" ./spring-petclinic-discovery-server
docker build --force-rm -t "petclinic-hystrix-dashboard:dev" ./spring-petclinic-hystrix-dashboard
docker build --force-rm -t "petclinic-vets-service:dev" ./spring-petclinic-vets-service
docker build --force-rm -t "petclinic-visits-service:dev" ./spring-petclinic-visits-service
docker build --force-rm -t "petclinic-grafana-server:dev" ./docker/grafana
docker build --force-rm -t "petclinic-prometheus-server:dev" ./docker/prometheus
```

* Commit the changes, then push the new script to the remote repo.

``` bash
git add .
git commit -m 'added script for building docker images'
git push --set-upstream origin feature/msp-7
git checkout dev
git merge feature/msp-7
git push origin dev
```

## MSP 8 - Create Docker Compose File for Local Development

* Create `feature/msp-8` branch from `dev`.

``` bash
git checkout dev
git branch feature/msp-8
git checkout feature/msp-8
```

* Prepare docker compose file to deploy the application locally and save it as `docker-compose-local.yml`.

``` yaml
version: '2'

services:
  config-server:
    image: petclinic-config-server:dev
    container_name: config-server
    mem_limit: 512M
    ports:
     - 8888:8888

  discovery-server:
    image: petclinic-discovery-server:dev
    container_name: discovery-server
    mem_limit: 512M
    depends_on:
    - config-server
    entrypoint: ["./dockerize","-wait=tcp://config-server:8888","-timeout=60s","--","java", "-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]
    ports:
     - 8761:8761

  customers-service:
    image: petclinic-customers-service:dev
    container_name: customers-service
    mem_limit: 512M
    depends_on:
    - config-server
    - discovery-server
    entrypoint: ["./dockerize","-wait=tcp://discovery-server:8761","-timeout=60s","--","java", "-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]
    ports:
    - 8081:8081

  visits-service:
    image: petclinic-visits-service:dev
    container_name: visits-service
    mem_limit: 512M
    depends_on:
     - config-server
     - discovery-server
    entrypoint: ["./dockerize","-wait=tcp://discovery-server:8761","-timeout=60s","--","java", "-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]
    ports:
     - 8082:8082

  vets-service:
    image: petclinic-vets-service:dev
    container_name: vets-service
    mem_limit: 512M
    depends_on:
     - config-server
     - discovery-server
    entrypoint: ["./dockerize","-wait=tcp://discovery-server:8761","-timeout=60s","--","java", "-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]
    ports:
     - 8083:8083

  api-gateway:
    image: petclinic-api-gateway:dev
    container_name: api-gateway
    mem_limit: 512M
    depends_on:
     - config-server
     - discovery-server
    entrypoint: ["./dockerize","-wait=tcp://discovery-server:8761","-timeout=60s","--","java", "-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]
    ports:
     - 8080:8080

  tracing-server:
    image: openzipkin/zipkin
    container_name: tracing-server
    mem_limit: 512M
    environment:
    - JAVA_OPTS=-XX:+UnlockExperimentalVMOptions -Djava.security.egd=file:/dev/./urandom
    ports:
     - 9411:9411

  admin-server:
    image: petclinic-admin-server:dev
    container_name: admin-server
    mem_limit: 512M
    depends_on:
     - config-server
     - discovery-server
    entrypoint: ["./dockerize","-wait=tcp://discovery-server:8761","-timeout=60s","--","java", "-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]
    ports:
     - 9090:9090

  hystrix-dashboard:
    image: petclinic-hystrix-dashboard:dev
    container_name: hystrix-dashboard
    mem_limit: 512M
    depends_on:
     - config-server
     - discovery-server
    entrypoint: ["./dockerize","-wait=tcp://discovery-server:8761","-timeout=60s","--","java", "-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]
    ports:
     - 7979:7979

  ## Grafana / Prometheus

  grafana-server:
    image: petclinic-grafana-server:dev
    container_name: grafana-server
    mem_limit: 256M
    ports:
    - 3000:3000

  prometheus-server:
    image: petclinic-prometheus-server:dev
    container_name: prometheus-server
    mem_limit: 256M
    ports:
    - 9091:9090
```

* Prepare a script to test the deployment of the app locally with `docker-compose-local.yml` and save it as `test-local-deployment.sh`.

``` bash
docker-compose -f docker-compose-local.yml up
```

* Commit the change, then push the docker compose file to the remote repo.

``` bash
git add .
git commit -m 'added docker-compose file and script for local deployment'
git push --set-upstream origin feature/msp-8
git checkout dev
git merge feature/msp-8
git push origin dev
```

## MSP 9 - Setup Unit Tests and Configure Code Coverage Report