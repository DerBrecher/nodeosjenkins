#!/usr/bin/env groovy

pipeline {
    agent {
        node {
            label 'nodejs'
        }
    }

    options {
        timeout(time: 20, unit: 'MINUTES') 
    }

    stages {
        stage('Preample'){
            steps{
                script {
                    openshift.withCluster() {
                        openshift.withProject() {
                            echo "Using project: ${openshift.project()}"
                        }
                    }
                }
            }
        }
        stage('Build') {
            steps {
                echo 'Building..'
                sh 'sh ./build.sh'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
                sh 'cat test.txt'
                sh 'pwd'
                sh 'oc whoami'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}