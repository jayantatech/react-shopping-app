pipeline {

    environment {
        DOCKER_USERNAME="jaybiswas"
        EC2_IP="52.55.68.230"
        PROJECT_NAME="react-shopping-app"
        DOCKER_IMAGE="${DOCKER_USERNAME}/${PROJECT_NAME}"
        CONTAINER_NAME="${PROJECT_NAME}"
    }

    stages {
        stage("Pull form github") {
            steps {
                echo "Code pulling starting form github"
                checkout scm
                echo "Code pulling end form github"
            }
        }
        stage("build and push image") {
            steps {
                echo "building image"
                script {
                docker.withRegistry("", "docker-hub") {
                   sh """ 
                        echo "image build starting"
                        docker buildx build --platform linux/amd64 --push -t ${DOCKER_IMAGE}:latest .
                        echo "image build pushed ended"
                    """
                }
                }
            }
        }

        stage("update on EC2") {
            steps {
               echo "started to update the code"
               sshagent(["ec2-key"]) {
                sh """
                    ssh -o StrictHostKeyChecking=no ubuntu@${EC2_IP} '
                    docker pull ${DOCKER_IMAGE}:latest && 
                    (docker rm -f ${CONTAINER_NAME} || true) &&
                    docker run --name ${CONTAINER_NAME} -d -p 4050:80 --restart always ${DOCKER_IMAGE}:latest 
                    '
                """
               }
            }

        }

    }
}