pipeline {
    agent any

    tools {
        maven 'Maven3'
    }

    environment {
        SONARQUBE_ENV = 'SonarQubeServer'
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
                    sh 'mvn sonar:sonar'
                }
            }
        }

        stage('Package') {
            steps {
                sh 'mvn package'
            }
        }

        stage('Upload to Nexus') {
            steps {
                script {
                    nexusArtifactUploader(
                        nexusVersion: 'nexus3',
                        protocol: 'http',
                        nexusUrl: 'http://localhost:8081',
                        groupId: 'com.example',
                        version: '1.0',
                        repository: 'maven-releases',
                        credentialsId: 'nexus3 credentials',
                        artifacts: [
                            [
                                artifactId: 'spring-boot-webhook-jenkins',
                                classifier: '',
                                file: 'target/spring-boot-webhook-jenkins.jar',
                                type: 'jar'
                            ]
                        ]
                    )
                }
            }
        }
    }
}