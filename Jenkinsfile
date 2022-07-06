pipeline {
    agent any
    stages {
        stage('Check versions')
            steps {
                sh '''
                    git --version
                    mvn -version
                '''
            }
        stage('Clone repo')
            steps {
                sh '''
                    cd "$(mktemp -d)"
                    sh 'git clone https://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@github.com/davidmargolis/course-3-project-1.git'
                '''
            }
        stage('Package and validate maven app') {
            steps {
                sh 'mvn clean package sonar:sonar'
            }
        }
        stage('Build && SonarQube analysis') {
            steps {
                withSonarQubeEnv('My SonarQube Server') {
                    // Optionally use a Maven environment you've configured already
                    withMaven(maven:'Maven 3.5') {
                        sh 'mvn clean package sonar:sonar'
                    }
                }
            }
        }
        stage("Build Image") {
            steps {
                sh 'docker build -t course-3-project-1 .'
            }
        }
        stage("Push Image") {
            steps {
                sh 'docker push course-3-project-1'
            }
        }
    }
}
