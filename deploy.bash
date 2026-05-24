#!/bin/bash
set -euo pipefail

# ─── Args ────────────────────────────────────────────────────────────────────
PROJECT="$1"
IMAGE_NAME="$2"
CONTAINER_NAME="$3"
NETWORK="$4"
PORT="$5"
SECRET_MANAGER="$6"

# ─── Validate required args and env vars ─────────────────────────────────────
for ARG_NAME in PROJECT IMAGE_NAME CONTAINER_NAME NETWORK PORT SECRET_MANAGER; do
    [[ -z "${!ARG_NAME}" ]] && echo "ERROR: Argument '${ARG_NAME}' is empty or not set." && exit 1
done

for ENV_VAR in WORKSPACE JOB_NAME BRANCH_NAME BUILD_NUMBER BUILD_ID BUILD_DISPLAY_NAME; do
    [[ -z "${!ENV_VAR:-}" ]] && echo "WARNING: Environment variable '${ENV_VAR}' is not set."
done

# ─── Paths ────────────────────────────────────────────────────────────────────
OS_HOME="/home/ubuntu"
BRANCH="${BRANCH_NAME:-dev}"
JOB_DIR="${JOB_NAME:-unknown_job}"
BUILD_PATH="${OS_HOME}/BUILDS/${PROJECT}/${IMAGE_NAME}/${JOB_DIR}/${BRANCH}"
WORKSPACE_PATH="${WORKSPACE:-}"
SAVE_FILE_PATH="${OS_HOME}/container-configs/${BRANCH}/${IMAGE_NAME}"
AWS_DEFAULT_REGION="ap-southeast-2"

[[ -z "${WORKSPACE_PATH}" ]] && echo "ERROR: WORKSPACE env var is not set. Cannot copy build files." && exit 1

echo "========================================="
echo "Starting React App DEV deployment"
echo "========================================="

echo "Creating required directories..."
sudo mkdir -p "${BUILD_PATH}"
sudo mkdir -p "${WORKSPACE_PATH}"
sudo mkdir -p "${SAVE_FILE_PATH}"

echo "Copying workspace to build path..."


sudo cp -frp "${WORKSPACE_PATH}/." "${BUILD_PATH}"

echo "Removing .git directory..."
sudo rm -rf "${BUILD_PATH}/.git"

cd "${BUILD_PATH}"

echo "Fetching secrets from AWS Secrets Manager..."

# SECRET_JSON=$(aws secretsmanager get-secret-value \
#     --secret-id "${SECRET_MANAGER}" \
#     --query SecretString \
#     --output text)

# echo "${SECRET_JSON}" | jq -r \
# 'to_entries | map("\(.key)=\(.value|tostring)") | .[]' \
# | sudo tee "${SAVE_FILE_PATH}/.env.full" > /dev/null

# echo "Preparing React app env file..."

# ALLOWED_KEYS=$(jq -r '.env[]' "env.json")

# {
#     for key in ${ALLOWED_KEYS}; do
#         grep "^${key}=" "${SAVE_FILE_PATH}/.env.full" || \
#         echo "# Missing key: ${key}"
#     done
# } | sudo tee "${SAVE_FILE_PATH}/appConfig.env" > /dev/null

echo "Creating build metadata..."

BUILD_CONF=$(cat <<EOF
{
  "BUILD_NUMBER": "${BUILD_NUMBER:-0}-${BUILD_ID:-0}-${BUILD_DISPLAY_NAME:-N/A}-${JOB_NAME:-N/A}"
}
EOF
)

echo "${BUILD_CONF}" | sudo tee "${BUILD_PATH}/build_config.json" > /dev/null

echo "Stopping old container..."
docker rm -f "${CONTAINER_NAME}" 2>/dev/null || true


echo "Removing old image..."
# docker rmi -f "${IMAGE_NAME}:latest" 2>/dev/null || true
docker image prune -af || true


echo "Building docker image locally..."
# docker build -t "${IMAGE_NAME}:latest" .

docker buildx build \
  --platform linux/amd64 \
  -t "${IMAGE_NAME}:latest" .


echo "Starting new container..."
# When secrets are enabled, swap the line below with the --env-file variant:
# docker run -d --name "${CONTAINER_NAME}" -p "${PORT}" --env-file "${SAVE_FILE_PATH}/appConfig.env" "${IMAGE_NAME}:latest"
docker run -d \
  --name "${CONTAINER_NAME}" \
  --network "${NETWORK}" \
  -p "${PORT}" \
  "${IMAGE_NAME}:latest"


echo "Cleaning dangling images..."
docker image prune -f

echo "Running containers..."
docker ps -a

echo "========================================="
echo "React App DEV deployment completed successfully"
echo "========================================="