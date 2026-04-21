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
                    sh 'mvn sonar:sonar'
                }
            }
        }

        stage('Quality Gate') {
            steps {
                waitForQualityGate abortPipeline: true
            }
        }

        stage('Package') {
            steps {
                sh 'mvn package'
            }
        }

        stage('Upload to Nexus') {
            steps {
                nexusArtifactUploader(
                    nexusVersion: 'nexus3',
                    protocol: 'http',
                    nexusUrl: 'localhost:8081',
                    groupId: 'com.example',
                    version: '1.0',
                    repository: 'maven-releases',
                    credentialsId: 'nexus3-credentials',
                    artifacts: [
                        [
                            artifactId: 'spring-boot-webhook-jenkins',
                            classifier: '',
                            file: 'target/*.jar',
                            type: 'jar'
                        ]
                    ]
                )
            }
        }
    }
}