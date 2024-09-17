def elasticsearch_version = '8.15.1'

pipeline {
  agent any

  triggers {
    cron('H 2 * * *')
  }

  options {
    buildDiscarder(logRotator(numToKeepStr: '30'))
  }

  parameters {
    booleanParam(name: 'deployES', defaultValue: false, description: 'Deploy elasticsearch to maven repository')
  }

  stages {

    stage('Build') {
      steps {
        script {
          docker.build('prepare-es').inside {
            sh "./prepare-elasticsearch.sh ${elasticsearch_version}"
          }
        }
      }
    }

    stage('Deploy') {
      when {
        expression { params.deployES }
      }
      steps {
        script {
          docker.build("maven-build", "-f Dockerfile.maven .").inside {
            maven cmd: "deploy -Delasticsearch.version=${elasticsearch_version}"
          }
        }
      }
    }
  }
}
