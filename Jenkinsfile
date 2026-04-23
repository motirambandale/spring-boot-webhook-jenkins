pipeline {
    agent any

    options {
        skipDefaultCheckout(true)
    }

    tools {
        maven 'M3'
        jdk 'JDK17'
    }

 

    stages {

        stage('Clean Workspace') {
            steps {
                deleteDir()
            }
        }

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
              sh 'docker build -t spring-boot-webhook-jenkins:latest .'
         }    
     }
     
     stage('Tag Image') {
    steps {
        sh '''
        docker tag spring-boot-webhook-jenkins:latest spring-boot-webhook-jenkins:1.0.0
        '''
    }
   }
   
stage('Push Image to Nexus') {
    steps {
        sh '''
        echo "MotiJava@0208" | docker login host.docker.internal:8082 -u admin --password-stdin

        docker tag spring-boot-webhook-jenkins:1.0.0 host.docker.internal:8082/spring-boot-webhook-jenkins:1.0.0
        docker push host.docker.internal:8082/spring-boot-webhook-jenkins:1.0.0
        '''
    }
}
  
  stage('Deploy to Kubernetes') {
    steps {
        sh '''
        kubectl apply -f k8s-deployment.yaml
        kubectl apply -f k8s-service.yaml
        '''
    }
}
  
  
     
    }
}