pipeline {

    agent any

    environment {
        DOCKER_USERNAME="jaybiswas"
        PROJECT_NAME="react-shopping-app"
        DOCKER_IMAGE="${DOCKER_USERNAME}/${PROJECT_NAME}"

        // DEV environment
        DEV_EC2_IP="52.55.68.230"
        DEV_CONTAINER_NAME="react-shopping-app-dev"
        DEV_PORT="3000:80"
        DEV_NETWORK="react_dev_network"
        DEV_SECRET_MANAGER="react-app-dev-secrets"

    }


    stages {
        stage("pull form github") {
            steps {

            echo "Pulling from github"
            checkout scm 

            echo "code pulling completed"
            }
        }

        // stage("build and push code") {
        //     steps {
        //          echo "Building and pushing image"
        //          script {
        //             sh """
        //             chmod +x build.bash 
        //             ./build.bash 

        //             """
        //          }
        //     }
        // }

        stage("deploy to dev") {

            when {
                branch "dev"
            }

            steps {
               echo "Deploying to DEV environment"
                sshagent(["ec2-key"]) {
                    sh """ 
                        ssh -o StrictHostKeyChecking=no ubuntu@${DEV_EC2_IP} '
                        cd /home/ubuntu
                        chmod +x deploy.bash

                        export WORKSPACE="${WORKSPACE}"
                        export JOB_NAME="${JOB_NAME}"
                        export BRANCH_NAME="${BRANCH_NAME}"
                        export BUILD_NUMBER="${BUILD_NUMBER}"
                        export BUILD_ID="${BUILD_ID}"
                        export BUILD_DISPLAY_NAME="${BUILD_DISPLAY_NAME}"

                        docker network create ${DEV_NETWORK} 2>/dev/null || true

                        ./deploy.bash "${PROJECT_NAME}" "${PROJECT_NAME}" "${DEV_CONTAINER_NAME}" "${DEV_NETWORK}" "${DEV_PORT}" "${DEV_SECRET_MANAGER}"
                    '
 
                    """
                }



            }
        }
    }
}