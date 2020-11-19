pipeline {
    agent { label "master" }
    environment {
        ECR_REGISTRY = "016356827677.dkr.ecr.us-east-1.amazonaws.com"
        APP_REPO_NAME= "clarusway-repo/phonebook-app"
    }
    stages {
        stage('Build Docker Image') {
            steps {
                sh 'aws ecr create-repository \
                    --repository-name $APP_REPO_NAME \
                    --image-scanning-configuration scanOnPush=false \
                    --image-tag-mutability IMMUTABLE'
                sh 'docker build --force-rm -t "$ECR_REGISTRY/$APP_REPO_NAME:latest" .'
                sh 'docker image ls'
            }
        }
        stage('Push Image to ECR Repo') {
            steps {
                sh 'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin "$ECR_REGISTRY"'
                sh 'docker push "$ECR_REGISTRY/$APP_REPO_NAME:latest"'
            }
        }
        stage('CloudFromation Template creating') {
            steps {
                sh 'aws cloudformation create-stack --stack-name swarmcluster \
                    --template-body file://phonebook-cfn-template.yml \
                    --parameters ParameterKey=KeyPairName,ParameterValue=secure'
            }
        }
        stage('Deploy') {
            steps {
                sh 'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin "$ECR_REGISTRY"'
                sh 'docker stack deploy -c ./docker-compose.yml phonebook-app'
            }
        }

    }
    post {
        always {
            echo 'Deleting all local images'
            sh 'docker image prune -af'
        }
    }
}