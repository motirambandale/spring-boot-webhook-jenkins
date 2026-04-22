pipeline {
    agent any

    tools {
        maven 'Maven3'
    }

    stages {

        stage('Checkout Code') {
            steps {
                git 'https://github.com/motirambandale/spring-boot-webhook-jenkins.git'
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
                    sh 'mvn clean verify sonar:sonar'
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
        
            stage('Deploy') {
            steps {
                sh '''
                docker build -t spring-boot-webhook-jenkins:latest .
                docker run -d --name spring-boot-webhook-jenkins -p 8085:8085 spring-boot-webhook-jenkins:latest
                '''
            }
        }
    }
}