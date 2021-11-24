pipeline {
    agent {
        docker { image 'amazoncorretto:17-alpine' }
        args '-v $HOME/.gradle:/root/.gradle'
    }

  parameters {
    string(name: 'STACK_NAME', defaultValue: 'course-api-gateway', description: 'Enter the CloudFormation Stack Name.')
    string(name: 'PARAMETERS_FILE_NAME', defaultValue: 'stack-params.yml', description: 'Enter the Parameters File Name (Must contain file extension type *.yml)')
    string(name: 'TEMPLATE_NAME', defaultValue: 'application.yml', description: 'Enter the CloudFormation Template Name (Must contain file extension type *.yml)')
    credentials(name: 'CFN_CREDENTIALS_ID', defaultValue: 'course-jenkins', description: 'AWS Account Role.', required: true)
    choice(
      name: 'REGION',
      choices: ['eu-central-1'],
      description: 'AWS Account Region'
    )
    choice(
      name: 'ACTION',
      choices: ['deploy-stack', 'delete-stack'],
      description: 'CloudFormation Actions'
    )
    choice(
      name: 'ENVIRONMENT',
      choices: ['dev', 'test', 'prod'],
      description: 'CloudFormation Actions'
    )
  }

  stages {
    stage('Check version') {
      steps {
        ansiColor('xterm') {
          container("jenkins-agent") {
            sh 'aws --version'
            sh 'aws sts get-caller-identity'
          }
        }
      }
    }

    stage('Test') {
      when {
        expression { params.ACTION == 'deploy-stack' }
      }
      steps {
        ansiColor('xterm') {
          container("jenkins-agent") {
            sh './gradlew clean build'
          }
        }
      }
    }

    stage('Build & Push docker image') {
      when {
        expression { params.ACTION == 'deploy-stack' }
      }
      steps {
        ansiColor('xterm') {
          container("jenkins-agent") {
            docker.withRegistry('https://public.ecr.aws/k7s0v3p5/course-microservices') {
              docker
                .build("course-api-gateway:${env.BUILD_ID}")
                .push();
              }
          }
        }
      }
    }

    stage('Deploy-stack') {
      when {
        expression { params.ACTION == 'deploy-stack' }
      }
      steps {
        ansiColor('xterm') {
          container("jenkins-agent") {
            withCredentials([[
              $class: 'AmazonWebServicesCredentialsBinding',
              credentialsId: "${CFN_CREDENTIALS_ID}",
              accessKeyVariable: 'AWS_ACCESS_KEY_ID',
              secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                sh 'sed -i 's/\${ENVIRONMENT}/params.ENVIRONMENT/g' stack-params.yml'
                sh 'sed -i 's/\${BUILD_NUMBER}/env.BUILD_NUMBER/g' stack-params.yml'
                sh 'configuration/jenkins/scripts/deploy-stack.sh ${STACK_NAME} ${PARAMETERS_FILE_NAME} ${TEMPLATE_NAME} ${REGION}'
            }
          }
        }
      }
    }

    stage('Delete-stack') {
      when {
        expression { params.ACTION == 'delete-stack' }
      }
      steps {
        ansiColor('xterm') {
          container("jenkins-agent") {
            withCredentials([[
              $class: 'AmazonWebServicesCredentialsBinding',
              credentialsId: "${CFN_CREDENTIALS_ID}",
              accessKeyVariable: 'AWS_ACCESS_KEY_ID',
              secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                sh 'configuration/jenkins/scripts/delete-stack.sh ${STACK_NAME} ${REGION}'
            }
          }
        }
      }
    }
  }
}
