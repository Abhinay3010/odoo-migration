pipeline {
    agent any

    environment {
        DB_HOST = '127.0.0.1'
        DB_PORT = '5432'
        DB_USER = 'odoo_user_new'
        DB_PASS = credentials('db-cred')       // Jenkins credential ID for DB password
        UPGRADE_PATH = '/opt/migration/openupgrade'
        DOCKER_IMAGE = 'odoo-migration:latest'
    }

    parameters {
        string(name: 'DB_NAME', defaultValue: 'ngxsu_testing_db_2210_18_demo', description: 'Database name to migrate')
    }

    options {
        timeout(time: 60, unit: 'MINUTES')     // Prevent pipeline from hanging indefinitely
        ansiColor('xterm')                     // For colored logs
        timestamps()                            // Show timestamps in logs
    }

    stages {

        stage('Checkout Repo') {
            steps {
                echo "🔄 Checking out repo..."
                git branch: 'main',
                    url: 'https://github.com/Abhinay3010/odoo-migration.git',
                    credentialsId: 'github-token'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "🛠 Building Docker image..."
                sh '''
                    docker build --pull \
                        -t $DOCKER_IMAGE \
                        -f docker/Dockerfile .
                '''
            }
        }

        stage('Run Migration') {
            steps {
                echo "🚀 Running Odoo migration in Docker container..."
                sh '''
                    docker run --rm --network host \
                        -e DB_NAME=${DB_NAME} \
                        -e DB_HOST=${DB_HOST} \
                        -e DB_PORT=${DB_PORT} \
                        -e DB_USER=${DB_USER} \
                        -e DB_PASS=${DB_PASS} \
                        -e UPGRADE_PATH=${UPGRADE_PATH} \
                        -v $WORKSPACE:/workspace \
                        -w /workspace \
                        $DOCKER_IMAGE
                '''
            }
        }
    }

    post {
        success {
            echo '✅ Migration completed successfully!'
            echo 'Reports saved under: migration_reports/'
        }
        failure {
            echo '❌ Migration failed. Check logs!'
        }
        always {
            cleanWs()  // Clean workspace after every run to avoid leftover files
        }
    }
}
