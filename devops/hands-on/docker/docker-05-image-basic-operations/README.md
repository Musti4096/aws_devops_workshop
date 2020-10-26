# Hands-on Docker-05 : Docker Image Basic Operations

Purpose of the this hands-on training is to give the students understanding to images in Docker.

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- explain what Docker image is.

- explain Docker image layers.

- list images in Docker.

- explain Docker Hub.

- have a Docker Hub account and create a repository.

- pull Docker images.

- explain image tags.

- inspect Docker image.

- search for Docker images.

- explain what the Dockerfile is.

- build images with Dockerfile.

- push images to Docker Hub.

- delete Docker images.

## Outline

- Part 1 - Launch a Docker Machine Instance and Connect with SSH

- Part 2 - Using Docker Image Commands and Docker Hub

- Part 3 - Building Docker Images with Dockerfile

## Part 1 - Launch a Docker Machine Instance and Connect with SSH

- Launch a Docker machine on Amazon Linux 2 AMI with security group allowing SSH connections using the [Cloudformation Template for Docker Machine Installation](../docker-01-installing-on-ec2-linux2/docker-installation-template.yml).

- Connect to your instance with SSH.

```bash
ssh -i .ssh/call-training.pem ec2-user@ec2-3-133-106-98.us-east-2.compute.amazonaws.com
```

## Part 2 - Using Docker Image Commands and Docker Hub

- Explain what the Docker Hub is.

- Sign up to Docker Hub and explain the UI.

- Create a repository with the name of `flask-app` and description of `This image repo holds Flask apps on Python:Alpine`.

- Check if the docker service is up and running on EC2 instance.

```bash
systemctl status docker
```

- List images in Docker and explain properties of images.

```bash
docker image ls
```

- Download Docker image `ubuntu` and explain image tags (defaults to `latest`) on Docker Hub. Show `ubuntu` repo on Docker Hub and which version the `latest` tag corresponds to (`20.04`).

```bash
# Defaults to ubuntu:latest
docker image pull ubuntu
docker image ls
```

- Run `ubuntu` as container with interactive shell open.

```bash
docker run -it ubuntu
```

- Display the `ubuntu` os info on the container (`VERSION="20.04 LTS (Focal Fossa)"`) and note that the `latest` tag is showing release `20.04` as in the Docker Hub. Then exit the container.

```bash
cat /etc/os-release
exit
```

- Download earlier version (`18.04`) of `ubuntu` image, which is tagged as `18.04` on Docker Hub and explain image list.

```bash
docker image pull ubuntu:18.04
docker image ls
```

- Inspect `ubuntu` image and explain properties.

```bash
# Defaults to ubuntu:latest
docker image inspect ubuntu
# Ubuntu with tag 18.04
docker image inspect ubuntu:18.04
```

- Show the history of image `ubuntu` and explain Docker image layers.

```bash
docker image history ubuntu
```

- Search for Docker Images both on `bash` and on Docker Hub. Show which version of Python corresponds to when `python:alpine` selected. (`3.8.5`)
  
```bash
docker search python
```

## Part 3 - Building Docker Images with Dockerfile

- Build an image of Python Flask app with Dockerfile based on `python:alpine` image and push it to the Docker Hub.

- Create a folder to hold all files necessary for creating Docker image.

```bash
mkdir clarusway_web
cd clarusway_web
```

- Create application code and save it to file, and name it `welcome.py`

```bash
echo '
from flask import Flask
app = Flask(__name__)
@app.route("/")
def hello():
    return "<h1>Welcome to Clarusway</h1>"
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)
' > welcome.py
```

- Create a file listing necessary packages and modules, and name it `requirements.txt`

```bash
echo '
flask
' > requirements.txt
```

- Create a Dockerfile listing necessary packages and modules, and name it `Dockerfile`
  
```bash
echo '
FROM python:alpine
COPY . /app
WORKDIR /app
RUN pip install -r requirements.txt
EXPOSE 80
CMD python ./welcome.py
' > Dockerfile
```

- Build Docker image from Dockerfile locally, tag it as `<Your_Docker_Hub_Account_Name>/<Your_Image_Name>:<Tag>` and explain steps of building. Note that repo name is the combination of `<Your_Docker_Hub_Account_Name>/<Your_Image_Name>`.

```bash
docker build -t "callahanclarus/flask-app:1.0" .
docker image ls
```

- Run the newly built image as container in detached mode, connect host `port 80` to container `port 80`, and name container as `welcome`. Then list running containers and connect to EC2 instance from the browser to show the Flask app is running.

```bash
docker run -d --name welcome -p 80:80 callahanclarus/flask-app:1.0
docker ps
```

- Stop and remove the container `welcome`.

```bash
docker stop welcome && docker rm welcome
```

- Login in to Docker with credentials.

```bash
docker login
```

- Push newly built image to Docker Hub, and show the updated repo on Docker Hub.

```bash
docker push callahanclarus/flask-app
```

- Delete image with `image id` locally.

```bash
docker image rm 497
```
