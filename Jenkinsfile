pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'dockerhub_ardixus' // Replace with your Docker Hub credentials ID in Jenkins
        GIT_REPO = 'https://github.com/ardixus/my_firstime.git' // Replace with your GitHub repository URL
        DOCKER_IMAGE = 'ardixus/appjendoc01' // Replace with your Docker Hub username and image name
        KUBERNETES_NAMESPACE = 'jenks' // Replace with your desired Kubernetes namespace
        KUBE_CONFIG = 'C:\Users\User\.kube\config'
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
                    powershell 'minikube start'
                    powershell 'kubectl config use-context minikube --kubeconfig=${KUBE_CONFIG}'
                    powershell "kubectl set image deployment/appjendoc01 web-app=${env.DOCKER_IMAGE}:${env.BUILD_NUMBER} -n ${env.KUBERNETES_NAMESPACE} || kubectl apply -f k8s\\deployment.yaml -n ${env.KUBERNETES_NAMESPACE} --kubeconfig=${KUBE_CONFIG}"
                    powershell 'kubectl apply -f k8s\\service.yaml -n ${env.KUBERNETES_NAMESPACE} --kubeconfig=${KUBE_CONFIG}'
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

