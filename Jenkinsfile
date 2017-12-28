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
    DASHBOARD           = 'http://observ.dashboard.observ.bigboat.cloud'
    APPLICATION_NAME    = 'appstarter'
    INSTANCE_NAME       = 'app-$BUILD_NUMBER'
  }
  options {
    buildDiscarder(logRotator(numToKeepStr:'10'))
  }

  stages {
    stage('Initialize') {
      steps {
        script {
          checkout scm
          sh "echo version=$BUILD_NUMBER > .env"
        }
      }
    }
    stage('Build backend') {
      steps {
        script {
          wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
            sh """
              docker run --rm -it -v $M2_PATH:/root/.m2 -v $PWD/backend:/work -w /work maven:3-jdk-8-alpine mvn package
              
              docker build -t http://www.docker-registry.observ.bigboat.cloud:5000/appstarter-backend:$BUILD_NUMBER ./backend
              docker tag http://www.docker-registry.observ.bigboat.cloud:5000/appstarter-backend:$BUILD_NUMBER http://www.docker-registry.observ.bigboat.cloud:5000/appstarter-backend:latest
              docker push http://www.docker-registry.observ.bigboat.cloud:5000/appstarter-backend:$BUILD_NUMBER
              docker push http://www.docker-registry.observ.bigboat.cloud:5000/appstarter-backend:latest
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
              docker run --rm -it -v $NPM_PATH:/root/.npm -v $PWD/frontend:/work -w /work node npm i
              docker run --rm -it -v $NPM_PATH:/root/.npm -v $PWD/frontend:/work -w /work node npm run build

              docker build -t http://www.docker-registry.observ.bigboat.cloud:5000/appstarter-frontend:$BUILD_NUMBER ./frontend
              docker tag http://www.docker-registry.observ.bigboat.cloud:5000/appstarter-frontend:$BUILD_NUMBER http://www.docker-registry.observ.bigboat.cloud:5000/appstarter-frontend:latest
              docker push http://www.docker-registry.observ.bigboat.cloud:5000/appstarter-frontend:$BUILD_NUMBER
              docker push http://www.docker-registry.observ.bigboat.cloud:5000/appstarter-frontend:latest
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