pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'dockerhub-credentials-id' // Replace with your Docker Hub credentials ID in Jenkins
        GIT_REPO = 'https://github.com/your-username/your-repo.git' // Replace with your GitHub repository URL
        DOCKER_IMAGE = 'ardixus/appjendoc01' // Replace with your Docker Hub username and image name
        KUBERNETES_NAMESPACE = 'appsweb' // Replace with your desired Kubernetes namespace
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: "${env.GIT_REPO}"
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${env.DOCKER_IMAGE}:${env.BUILD_NUMBER}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', "${env.DOCKER_CREDENTIALS_ID}") {
                        docker.image("${env.DOCKER_IMAGE}:${env.BUILD_NUMBER}").push()
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh 'kubectl config use-context minikube'
                    sh "kubectl set image deployment/your-app your-app=${env.DOCKER_IMAGE}:${env.BUILD_NUMBER} -n ${env.KUBERNETES_NAMESPACE} || kubectl apply -f k8s/deployment.yaml -n ${env.KUBERNETES_NAMESPACE}"
                    sh 'kubectl apply -f k8s/service.yaml -n ${env.KUBERNETES_NAMESPACE}'
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}

