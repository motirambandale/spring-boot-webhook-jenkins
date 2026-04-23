pipeline {
    agent any

    tools {
        maven 'M3'
        jdk 'JDK17'
    }

    environment {
        IMAGE_NAME = "spring-boot-webhook-jenkins"
    }

    stages {
      stage('Checkout') {
        steps {
           checkout scm
          }
       }

        stage('Build') {
            steps {
                sh 'mvn clean compile'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQubeServer') {
                    sh 'mvn verify sonar:sonar'
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 2, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Package') {
            steps {
                sh 'mvn package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME:latest .'
            }
        }

        stage('Deploy Container') {
            steps {
                sh '''
                    docker rm -f $IMAGE_NAME || true
                    docker run -d -p 8085:8085 --name $IMAGE_NAME $IMAGE_NAME:latest
                '''
            }
        }
    }
}