#!groovy
pipeline {
  agent {
    label 'docker'
  }

  environment {
    NPM_PATH = '${HOME}/.npm'
    M2_PATH = '${HOME}/.m2'
    SONAR_PATH = '${HOME}/.sonar'
    DASHBOARD_API_KEY = '7e4ebec3236ae50e8dfce99ba6fa47a2'
    DASHBOARD = 'test.dashboard.hyperdev.cloud'
    APPLICATION_NAME = 'appstarter'
    SONAR_QUALITY_GATE_TIMEOUT = '2'
    SONAR_QUALITY_GATE_TIMEOUT_UNIT = 'MINUTES'
    DOCKER_REGISTRY = 'repo.docker-registry.test.hyperdev.cloud:5000'
    SONAR_URL = 'http://www.sonarqube.test.hyperdev.cloud:9000'
    MAVEN_SCM_URL = 'scm:git:git@www.gitlab.test.hyperdev.cloud:appstarter/appstarter.git'
    NEXUS_DISTRIBUTION_REPOSITORY = 'http://admin:admin123@www.nexus.test.hyperdev.cloud:8081/repository/maven-releases'
    NEXUS_REPOSITORY = 'http://www.nexus.test.hyperdev.cloud:8081/repository/maven-public/'
  }
  options {
    buildDiscarder(logRotator(numToKeepStr:'10'))
    disableConcurrentBuilds()
  }

  stages {
    stage('Initialize') {
      steps {
        script {
          sh "git checkout ${env.BRANCH_NAME}"
          
          if(env.BRANCH_NAME == 'master') {
            env.VERSION = "${env.BUILD_NUMBER}"
          } else {
            env.VERSION = "${env.BRANCH_NAME.take(10)}"
          }
          env.INSTANCE_NAME="app-${env.VERSION.replaceAll('\\.', '-').toLowerCase()}"

          echo "version: ${env.VERSION}"
          echo "instanceName: ${env.INSTANCE_NAME}"
        }
      }
    }
    stage('Build') {
      parallel {
        stage('Build backend') {
          steps {
            wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
              sh """
                cd backend
                docker build --no-cache -t ${env.DOCKER_REGISTRY}/appstarter-backend:${env.VERSION} \
                  --build-arg SONAR_URL=${env.SONAR_URL} \
                  --build-arg NEXUS_REPOSITORY=${env.NEXUS_REPOSITORY} \
                  --build-arg NEXUS_DISTRIBUTION_REPOSITORY=${env.NEXUS_DISTRIBUTION_REPOSITORY} \
                  --build-arg MAVEN_SCM_URL=${env.MAVEN_SCM_URL} .
              """
          }}
        }
        stage('Build frontend') {
          steps {
            wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
              sh """
                cd frontend
                docker build --no-cache -t ${env.DOCKER_REGISTRY}/appstarter-frontend:${env.VERSION} .
              """
            }
          }
        }
      }
    }
    // stage('Test Backend') {
    //   agent {
    //     docker {
    //       image 'maven:3-alpine'
    //       args "-v /var/jenkins_home/.m2:/root/.m2"
    //     }
    //   }
    //   steps {
    //     withSonarQubeEnv('SonarQube') {
    //       sh """
    //         mvn -f backend/pom.xml -Dsonar.branch=\$BRANCH_NAME -B test sonar:sonar \
    //           -Dsonar.host.url=$SONAR_URL \
    //           -Dnexus.repository=$NEXUS_REPOSITORY \
    //           -Dnexus.distribution.repository=$NEXUS_DISTRIBUTION_REPOSITORY \
    //           -Dmaven.scm.url=$MAVEN_SCM_URL
    //       """
    //     }

    //     junit 'backend/**/target/surefire-reports/**/*.xml'
    //   }
    // }
    // stage("Backend SonarQube Quality Gate") {
    //   steps {
    //     timeout(time: env.SONAR_QUALITY_GATE_TIMEOUT as int, unit: env.SONAR_QUALITY_GATE_TIMEOUT_UNIT) {
    //       script {
    //         def qg = waitForQualityGate() 
    //         if (qg.status != 'OK') {
    //             error "Pipeline aborted due to quality gate failure: ${qg.status}"
    //         }

    //         // Clean up report-task before next stage.
    //         sh 'rm -f ../**/backend/target/sonar/report-task.txt'
    //       }
    //     }
    //   }
    // }
    // stage('Test Frontend') {
    //   agent {
    //     dockerfile {
    //       dir '.jenkins/'
    //       args "-v /var/jenkins_home/.npm:/.npm"
    //     }
    //   }
    //   steps {
    //     wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
    //       withSonarQubeEnv('SonarQube') {
    //         sh '''
    //           cd frontend
    //           npm i
    //           npm run test:ci
    //           npm run sonar-scanner -- -Dsonar.branch=$BRANCH_NAME
    //           '''
    //       }

    //       junit 'frontend/reports/**/*-junit.xml'
    //     }
    //   }
    // }
    // stage("Frontend SonarQube Quality Gate") {
    //   steps {
    //     timeout(time: env.SONAR_QUALITY_GATE_TIMEOUT as int, unit: env.SONAR_QUALITY_GATE_TIMEOUT_UNIT) {
    //       script {
    //         def qg = waitForQualityGate() 
    //         if (qg.status != 'OK') {
    //             error "Pipeline aborted due to quality gate failure: ${qg.status}"
    //         }
    //       }
    //     }
    //   }
    // }
    stage('Packaging') {
      steps {
        script {
          wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
            sh """
              cd proxy
              docker build -t ${env.DOCKER_REGISTRY}/appstarter-proxy:${env.VERSION} .
              docker tag ${env.DOCKER_REGISTRY}/appstarter-proxy:${env.VERSION} ${env.DOCKER_REGISTRY}/appstarter-proxy:latest
              docker push ${env.DOCKER_REGISTRY}/appstarter-proxy:${env.VERSION}
              docker push ${env.DOCKER_REGISTRY}/appstarter-proxy:latest

              cd ../backend
              docker tag ${env.DOCKER_REGISTRY}/appstarter-backend:${env.VERSION} ${env.DOCKER_REGISTRY}/appstarter-backend:latest
              docker push ${env.DOCKER_REGISTRY}/appstarter-backend:${env.VERSION}
              docker push ${env.DOCKER_REGISTRY}/appstarter-backend:latest

              cd ../frontend
              docker tag ${env.DOCKER_REGISTRY}/appstarter-frontend:${env.VERSION} ${env.DOCKER_REGISTRY}/appstarter-frontend:latest
              docker push ${env.DOCKER_REGISTRY}/appstarter-frontend:${env.VERSION}
              docker push ${env.DOCKER_REGISTRY}/appstarter-frontend:latest

              cd ..
              echo version=${env.VERSION} > .env
              echo docker_registry=${env.DOCKER_REGISTRY} >> .env

              rm -f docker-compose.complete.yml
              
              docker-compose config > docker-compose.incomplete.yml
              cat docker-compose.incomplete.yml
              cat docker-compose.incomplete.yml | sed 's/\\\$\\\$/\\\$/g' > docker-compose.complete.yml

              cat docker-compose.complete.yml
            """
          }
        }
      }
    }
    // stage('Start App') {
    //   steps {
    //     script {
    //       echo 'start app'
    //       wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
    //         sh "ci/scripts/start-app.sh ${env.WORKSPACE}"
    //       }
    //     }
    //   }
    // }
    // stage('Run Automated Regressions Tests') {
    //   steps {
    //     script {
    //       wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
    //         sh """
    //           set +e
    //           docker run --entrypoint=/bin/bash --rm -t -v ${env.WORKSPACE}/test:/work testx/protractor \
    //             -c 'cd /work && npm i && /protractor.sh conf.coffee --baseUrl="http://www.${env.INSTANCE_NAME}.test.hyperdev.cloud/"' || true
    //         """

    //         junit 'test/**/junit/*.xml'
    //       }
    //     }
    //   }
    // }
  }
  post {
    always {
      script {
        echo 'post.always'
        wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
          echo 'skip'
          sh "ci/scripts/stop-app.sh"
        }

        cleanWs()
      }
    }
    success {
      script {
        echo 'post.success'
      }
    }
  }
}
