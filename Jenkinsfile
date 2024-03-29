def elasticsearch_version = '7.17.19'

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
          docker.image("maven:3.9.6-eclipse-temurin-17").inside {
            maven cmd: "deploy -Delasticsearch.version=${elasticsearch_version}"
          }
        }
      }
    }
  }
}
