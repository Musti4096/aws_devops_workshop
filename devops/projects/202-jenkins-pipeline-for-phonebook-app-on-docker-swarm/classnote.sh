Project-202: Docker Swarm Deployment of Phonebook Application (Python Flask) with

Part-3

Date: 26/11/2020

Instructor: Serdar


- Infrastructure
    - Public Repository on Github (Codebase, Versionig System)
    - Docker Swarm as Orchestrator
        - 3 Manager
        - 2 Worker
    - Image Repository (AWS ECR)
    - Should be able to 
        - Every EC2 is able to talk each other (EC2 Connect CLI, IAM Policy)
        - Grand Master can pull image from ECR and push image to AWS ECR (ECR credential helper, reach ECR with cli command)
        - Mangers and Workers can pull image from AWS ECR. (ECR Credential helper)

- Application Deployement
    - Dockerfile
    - docker-compose.yml (Web server and Mysql)

Jenkins Server should be capable of
    - creating ECR Repository
    - building docker image
    - pushing Docker Imageto ECR Repository
    - creating infrastructure for Athe Application
    - Deploying the Application