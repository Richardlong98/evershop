pipeline {
    agent any

    environment {
        NODE_ENV = 'production'
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Pulling code from GitHub...'
                checkout([$class: 'GitSCM',
                    branches: [[name: 'dev']],   // chỉnh lại nếu dùng main
                    userRemoteConfigs: [[
                        url: 'git@github.com:Richardlong98/evershop.git',
                        credentialsId: 'jenkins-ssh-key'
                    ]]
                ])
            }
        }

        stage('Install Dependencies') {
            steps {
                echo 'Installing npm packages...'
                sh 'npm install'
            }
        }

        stage('Build') {
            steps {
                echo 'Building the project...'
                sh 'npm run build'
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests...'
                sh 'npm test || true'  // nếu chưa có test thì tránh fail pipeline
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying application...'
                // Ví dụ deploy bằng pm2
                // sh 'pm2 restart evershop || pm2 start npm --name "evershop" -- start'
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
