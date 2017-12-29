#!groovy
pipeline {
  agent {
    label 'docker'
  }

  environment {
    NPM_PATH            = '${HOME}/.npm'
    M2_PATH             = '${HOME}/.m2'
    SONAR_PATH          = '${HOME}/.sonar'
    DASHBOARD_API_KEY   = '8a8edbab83fc7809765822e1ee7385c3'
    DASHBOARD           = 'observ.dashboard.bigboat.cloud'
    APPLICATION_NAME    = 'appstarter'
    INSTANCE_NAME       = "app-${env.BUILD_NUMBER}"
  }
  options {
    buildDiscarder(logRotator(numToKeepStr:'10'))
  }

  stages {
    stage('Initialize') {
      steps {
        script {
          sh "docker run --rm -i -v ${env.WORKSPACE}:/work -w /work alpine rm -rf *"

          checkout scm
          sh "echo version=${env.BUILD_NUMBER} > .env"
        }
      }
    }
    stage('Build backend') {
      steps {
        script {
          wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
            sh """
              docker run --rm -i -v $M2_PATH:/root/.m2 -v $WORKSPACE/backend:/work -w /work maven:3-jdk-8-alpine mvn package
              
              docker build -t repo.docker-registry.observ.bigboat.cloud:5000/appstarter-backend:${env.BUILD_NUMBER} ./backend
              docker tag repo.docker-registry.observ.bigboat.cloud:5000/appstarter-backend:${env.BUILD_NUMBER} repo.docker-registry.observ.bigboat.cloud:5000/appstarter-backend:latest
              docker push repo.docker-registry.observ.bigboat.cloud:5000/appstarter-backend:${env.BUILD_NUMBER}
              docker push repo.docker-registry.observ.bigboat.cloud:5000/appstarter-backend:latest
            """
          }
        }
      }
    }
    stage('Build frontend') {
      steps {
        script {
          wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
            sh """
              docker run --rm -i -v $NPM_PATH:/root/.npm -v $WORKSPACE/frontend:/work -w /work node npm i
              docker run --rm -i -v $NPM_PATH:/root/.npm -v $WORKSPACE/frontend:/work -w /work node npm run build

              docker build -t repo.docker-registry.observ.bigboat.cloud:5000/appstarter-frontend:${env.BUILD_NUMBER} ./frontend
              docker tag repo.docker-registry.observ.bigboat.cloud:5000/appstarter-frontend:${env.BUILD_NUMBER} repo.docker-registry.observ.bigboat.cloud:5000/appstarter-frontend:latest
              docker push repo.docker-registry.observ.bigboat.cloud:5000/appstarter-frontend:${env.BUILD_NUMBER}
              docker push repo.docker-registry.observ.bigboat.cloud:5000/appstarter-frontend:latest
            """
          }
        }
      }
    }
    stage('Start App') {
      steps {
        script {
          echo 'start app'
          wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
            sh "ci/scripts/start-app.sh ${env.WORKSPACE}"
          }
        }
      }
    }
  }
  post {
    always {
      script {
        echo 'post.always'
        wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
          sh "ci/scripts/stop-app.sh"
        }
      }
    }
    success {
      script {
        echo 'post.success'
      }
    }
  }
}