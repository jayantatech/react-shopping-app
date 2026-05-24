pipeline {

    agent any

    environment {

        DOCKER_USERNAME = "jaybiswas"
        PROJECT_NAME    = "react-shopping-app"
        DOCKER_IMAGE    = "${DOCKER_USERNAME}/${PROJECT_NAME}"

        // ================= DEV =================

        DEV_EC2_IP         = "52.55.68.230"
        DEV_CONTAINER_NAME = "react-shopping-app-dev"
        DEV_PORT           = "3000:80"
        DEV_NETWORK        = "react_dev_network"
        DEV_SECRET_MANAGER = "react-app-dev-secrets"

        // ================= QA =================

        // QA_EC2_IP          = "0.0.0.0"
        // QA_CONTAINER_NAME  = "react-shopping-app-qa"
        // QA_PORT            = "3001:80"
        // QA_NETWORK         = "react_qa_network"
        // QA_SECRET_MANAGER  = "react-app-qa-secrets"

        // // ================= PROD =================

        // PROD_EC2_IP         = "0.0.0.0"
        // PROD_CONTAINER_NAME = "react-shopping-app-prod"
        // PROD_PORT           = "80:80"
        // PROD_NETWORK        = "react_prod_network"
        // PROD_SECRET_MANAGER = "react-app-prod-secrets"
    }

    stages {

        // =========================================================
        // DEV DEPLOYMENT
        // =========================================================

        stage("Deploy to DEV") {

            when {
                branch "dev"
            }

            steps {

                echo "Deploying to DEV environment"

                sshagent(["ec2-key"]) {

                    sh """
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

                            /home/ubuntu/deploy.bash \
                            "${PROJECT_NAME}" \
                            "${DOCKER_IMAGE}" \
                            "${DEV_CONTAINER_NAME}" \
                            "${DEV_NETWORK}" \
                            "${DEV_PORT}" \
                            "${DEV_SECRET_MANAGER}"
                        '
                    """
                }
            }
        }

        // =========================================================
        // QA DEPLOYMENT
        // =========================================================

        // stage("Deploy to QA") {

        //     when {
        //         branch "qa"
        //     }

        //     steps {

        //         echo "Deploying to QA environment"

        //         sshagent(["ec2-key"]) {

        //             sh """
        //                 scp -o StrictHostKeyChecking=no deploy.bash ubuntu@${QA_EC2_IP}:/home/ubuntu/deploy.bash

        //                 ssh -o StrictHostKeyChecking=no ubuntu@${QA_EC2_IP} '

        //                     chmod +x /home/ubuntu/deploy.bash

        //                     export WORKSPACE="${WORKSPACE}"
        //                     export JOB_NAME="${JOB_NAME}"
        //                     export BRANCH_NAME="${BRANCH_NAME}"
        //                     export BUILD_NUMBER="${BUILD_NUMBER}"
        //                     export BUILD_ID="${BUILD_ID}"
        //                     export BUILD_DISPLAY_NAME="${BUILD_DISPLAY_NAME}"

        //                     docker network create ${QA_NETWORK} 2>/dev/null || true

        //                     /home/ubuntu/deploy.bash \
        //                     "${PROJECT_NAME}" \
        //                     "${DOCKER_IMAGE}" \
        //                     "${QA_CONTAINER_NAME}" \
        //                     "${QA_NETWORK}" \
        //                     "${QA_PORT}" \
        //                     "${QA_SECRET_MANAGER}"
        //                 '
        //             """
        //         }
        //     }
        // }

        // =========================================================
        // PROD DEPLOYMENT
        // =========================================================

        // stage("Deploy to PROD") {

        //     when {
        //         branch "main"
        //     }

        //     steps {

        //         input message: "Deploy to Production?"

        //         echo "Deploying to PROD environment"

        //         sshagent(["ec2-key"]) {

        //             sh """
        //                 scp -o StrictHostKeyChecking=no deploy.bash ubuntu@${PROD_EC2_IP}:/home/ubuntu/deploy.bash

        //                 ssh -o StrictHostKeyChecking=no ubuntu@${PROD_EC2_IP} '

        //                     chmod +x /home/ubuntu/deploy.bash

        //                     export WORKSPACE="${WORKSPACE}"
        //                     export JOB_NAME="${JOB_NAME}"
        //                     export BRANCH_NAME="${BRANCH_NAME}"
        //                     export BUILD_NUMBER="${BUILD_NUMBER}"
        //                     export BUILD_ID="${BUILD_ID}"
        //                     export BUILD_DISPLAY_NAME="${BUILD_DISPLAY_NAME}"

        //                     docker network create ${PROD_NETWORK} 2>/dev/null || true

        //                     /home/ubuntu/deploy.bash \
        //                     "${PROJECT_NAME}" \
        //                     "${DOCKER_IMAGE}" \
        //                     "${PROD_CONTAINER_NAME}" \
        //                     "${PROD_NETWORK}" \
        //                     "${PROD_PORT}" \
        //                     "${PROD_SECRET_MANAGER}"
        //                 '
        //             """
        //         }
        //     }
        // }
    }

    post {

        success {
            echo "Pipeline completed successfully"
        }

        failure {
            echo "Pipeline failed"
        }

        always {
            echo "Pipeline finished"
        }
    }
}