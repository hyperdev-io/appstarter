#!groovy
pipeline {
  agent {
    label 'docker'
  }

  environment {
    NPM_PATH = '${HOME}/.npm'
    M2_PATH = '${HOME}/.m2'
    SONAR_PATH = '${HOME}/.sonar'
    DASHBOARD_API_KEY = '1ba7bc8eed1d74ff64d857f07df17ad1'
    DASHBOARD = 'test.dashboard.hyperdev.cloud'
    APPLICATION_NAME = 'appstarter'
    INSTANCE_NAME = "app-${env.BUILD_NUMBER}"
    SONAR_URL = 'http://www.sonarqube.test.hyperdev.cloud:9000'
    SONAR_QUALITY_GATE_TIMEOUT = '2'
    SONAR_QUALITY_GATE_TIMEOUT_UNIT = 'MINUTES'
    DOCKER_REGISTRY = 'repo.docker-registry.test.hyperdev.cloud:5000'
    MAVEN_SCM_URL = 'scm:git:git@www.gitlab.test.hyperdev.cloud:appstarter/appstarter.git'
    NEXUS_DISTRIBUTION_REPOSITORY = 'http://admin:admin123@www.nexus.test.hyperdev.cloud:8081/repository/maven-releases'
    NEXUS_REPOSIROTY = 'http://www.nexus.test.hyperdev.cloud:8081/repository/maven-public/'
  }
  options {
    buildDiscarder(logRotator(numToKeepStr:'10'))
  }

  stages {
    stage('Initialize') {
      steps {
        script {
          checkout scm
        }
      }
    }
    stage('Build') {
      parallel {
        stage('Build backend') {
          agent {
            docker {
              image 'maven:3-alpine'
              args "-v /var/jenkins_home/.m2:/root/.m2"
            }
          }
          steps {
            sh """
              mvn -f backend/pom.xml -B -DskipTests clean package \
                -Dsonar.host.url=$SONAR_URL \
                -Dnexus.repository=$NEXUS_REPOSIROTY \
                -Dnexus.distribution.repository=$NEXUS_DISTRIBUTION_REPOSITORY \
                -Dmaven.scm.url=$MAVEN_SCM_URL
            """
            stash name: 'backend-build', includes: '**/target/*'
          }
        }
        stage('Build frontend') {
          agent {
            docker {
              image 'node'
              args "-v /var/jenkins_home/.npm:/.npm"
            }
          }
          steps {
            wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
              sh """
                cd frontend
                npm i
                npm run build
              """
              stash name: 'frontend-build', includes: '**/build/**/*'
            }
          }
        }
      }
    }
    stage('Test Backend') {
      agent {
        docker {
          image 'maven:3-alpine'
          args "-v /var/jenkins_home/.m2:/root/.m2"
        }
      }
      steps {
        withSonarQubeEnv('SonarQube') {
          sh """
            mvn -f backend/pom.xml -Dsonar.branch=\$BRANCH_NAME -B test sonar:sonar \
              -Dsonar.host.url=$SONAR_URL \
              -Dnexus.repository=$NEXUS_REPOSIROTY \
              -Dnexus.distribution.repository=$NEXUS_DISTRIBUTION_REPOSITORY \
              -Dmaven.scm.url=$MAVEN_SCM_URL
          """
        }

        junit 'backend/**/target/surefire-reports/**/*.xml'
      }
    }
    stage("Backend SonarQube Quality Gate") {
      steps {
        timeout(time: env.SONAR_QUALITY_GATE_TIMEOUT as int, unit: env.SONAR_QUALITY_GATE_TIMEOUT_UNIT) {
          script {
            def qg = waitForQualityGate() 
            if (qg.status != 'OK') {
                error "Pipeline aborted due to quality gate failure: ${qg.status}"
            }

            // Clean up report-task before next stage.
            sh 'rm -f ../**/backend/target/sonar/report-task.txt'
          }
        }
      }
    }
    stage('Test Frontend') {
      agent {
        dockerfile {
          dir '.jenkins/'
          args "-v /var/jenkins_home/.npm:/.npm"
        }
      }
      steps {
        wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
          withSonarQubeEnv('SonarQube') {
            sh '''
              cd frontend
              npm i
              npm run test:ci
              npm run sonar-scanner -- -Dsonar.branch=$BRANCH_NAME
              '''
          }

          junit 'frontend/reports/**/*-junit.xml'
        }
      }
    }
    stage("Frontend SonarQube Quality Gate") {
      steps {
        timeout(time: env.SONAR_QUALITY_GATE_TIMEOUT as int, unit: env.SONAR_QUALITY_GATE_TIMEOUT_UNIT) {
          script {
            def qg = waitForQualityGate() 
            if (qg.status != 'OK') {
                error "Pipeline aborted due to quality gate failure: ${qg.status}"
            }
          }
        }
      }
    }
    stage('Packaging') {
      steps {
        script {
          wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
            unstash name: 'backend-build'
            unstash name: 'frontend-build'

            sh """
              cd proxy
              docker build -t ${env.DOCKER_REGISTRY}/appstarter-proxy:${env.BUILD_NUMBER} .
              docker tag ${env.DOCKER_REGISTRY}/appstarter-proxy:${env.BUILD_NUMBER} ${env.DOCKER_REGISTRY}/appstarter-proxy:latest
              docker push ${env.DOCKER_REGISTRY}/appstarter-proxy:${env.BUILD_NUMBER}
              docker push ${env.DOCKER_REGISTRY}/appstarter-proxy:latest

              cd ../backend
              docker build -t ${env.DOCKER_REGISTRY}/appstarter-backend:${env.BUILD_NUMBER} .
              docker tag ${env.DOCKER_REGISTRY}/appstarter-backend:${env.BUILD_NUMBER} ${env.DOCKER_REGISTRY}/appstarter-backend:latest
              docker push ${env.DOCKER_REGISTRY}/appstarter-backend:${env.BUILD_NUMBER}
              docker push ${env.DOCKER_REGISTRY}/appstarter-backend:latest

              cd ../frontend
              docker build -t ${env.DOCKER_REGISTRY}/appstarter-frontend:${env.BUILD_NUMBER} .
              docker tag ${env.DOCKER_REGISTRY}/appstarter-frontend:${env.BUILD_NUMBER} ${env.DOCKER_REGISTRY}/appstarter-frontend:latest
              docker push ${env.DOCKER_REGISTRY}/appstarter-frontend:${env.BUILD_NUMBER}
              docker push ${env.DOCKER_REGISTRY}/appstarter-frontend:latest

              cd ..
              echo version=${env.BUILD_NUMBER} > .env
              echo docker_registry=${env.DOCKER_REGISTRY} >> .env

              docker-compose config > docker-compose.complete.yml
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
    stage('Run Automated Regressions Tests') {
      steps {
        script {
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
          echo 'skip'
          // sh "ci/scripts/stop-app.sh"
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