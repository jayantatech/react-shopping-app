pipeline {

    agent any

    environment {
        DOCKER_USERNAME = "jaybiswas"
        PROJECT_NAME    = "react-shopping-app"
        DOCKER_IMAGE    = "${DOCKER_USERNAME}/${PROJECT_NAME}"

        // DEV environment
        DEV_EC2_IP         = "52.55.68.230"        // store IP in Jenkins credentials, not hardcoded
        DEV_CONTAINER_NAME = "react-shopping-app-dev"
        DEV_PORT           = "3000:80"
        DEV_NETWORK        = "react_dev_network"
        DEV_SECRET_MANAGER = "react-app-dev-secrets"
    }

    stages {

        stage("Pull from GitHub") {
            steps {
                echo "Pulling from GitHub"
                checkout scm
                echo "Code pull completed"
            }
        }

        // stage("Build and push image") {
        //     steps {
        //         echo "Building and pushing image"
        //         script {
        //             sh """
        //             chmod +x build.bash
        //             ./build.bash
        //             """
        //         }
        //     }
        // }

        stage("Deploy to DEV") {

            when {
                expression {
                    env.BRANCH_NAME == "dev"
                }
            }

            steps {
                echo "Deploying to DEV environment"
                sshagent(["ec2-key"]) {
                    sh """
                        # Copy the latest deploy.bash to the remote server before running it
                        scp -o StrictHostKeyChecking=no deploy.bash ubuntu@${DEV_EC2_IP}:/home/ubuntu/deploy.bash

                        ssh -o StrictHostKeyChecking=no ubuntu@${DEV_EC2_IP} '
                            chmod +x /home/ubuntu/deploy.bash

                            export WORKSPACE="${WORKSPACE}"
                            export JOB_NAME="${JOB_NAME}"
                            export BRANCH_NAME="${BRANCH_NAME}"
                            export BUILD_NUMBER="${BUILD_NUMBER}"
                            export BUILD_ID="${BUILD_ID}"
                            export BUILD_DISPLAY_NAME="${BUILD_DISPLAY_NAME}"

                            docker network create ${DEV_NETWORK} 2>/dev/null || true

                            /home/ubuntu/deploy.bash "${PROJECT_NAME}" "${DOCKER_IMAGE}" "${DEV_CONTAINER_NAME}" "${DEV_NETWORK}" "${DEV_PORT}" "${DEV_SECRET_MANAGER}"
                        '
                    """
                }
            }
        }
    }
}