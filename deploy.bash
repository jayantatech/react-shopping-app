# ─── Paths ────────────────────────────────────────────────────────────────────
OS_HOME="/home/ubuntu"
BRANCH="${BRANCH_NAME:-dev}"
JOB_BASE=$(echo "${JOB_NAME:-unknown_job}" | cut -d'/' -f1)
BUILD_PATH="${OS_HOME}/BUILDS/${PROJECT}/${JOB_BASE}/${BRANCH}"
WORKSPACE_PATH="${WORKSPACE:-}"
SAVE_FILE_PATH="${OS_HOME}/container-configs/${BRANCH}/${IMAGE_NAME}"
AWS_DEFAULT_REGION="ap-southeast-2"

[[ -z "${WORKSPACE_PATH}" ]] && echo "ERROR: WORKSPACE env var is not set." && exit 1

echo "========================================="
echo "Starting React App DEV deployment"
echo "========================================="

echo "Creating required directories..."
sudo mkdir -p "${OS_HOME}/BUILDS"
sudo mkdir -p "${OS_HOME}/container-configs"
sudo chown -R ubuntu:ubuntu "${OS_HOME}/BUILDS"
sudo chown -R ubuntu:ubuntu "${OS_HOME}/container-configs"
mkdir -p "${BUILD_PATH}"
mkdir -p "${SAVE_FILE_PATH}"

echo "Copying workspace to build path..."
cp -frp "${WORKSPACE_PATH}/." "${BUILD_PATH}"

echo "Removing .git directory..."
rm -rf "${BUILD_PATH}/.git"

cd "${BUILD_PATH}"

echo "Creating build metadata..."
cat <<EOF > "${BUILD_PATH}/build_config.json"
{
  "BUILD_NUMBER": "${BUILD_NUMBER:-0}",
  "BUILD_ID": "${BUILD_ID:-0}",
  "BUILD_DISPLAY_NAME": "${BUILD_DISPLAY_NAME:-N/A}",
  "JOB_NAME": "${JOB_NAME:-N/A}",
  "BRANCH": "${BRANCH}"
}
EOF

echo "Stopping old container..."
docker rm -f "${CONTAINER_NAME}" 2>/dev/null || true

echo "Removing old image..."
docker image prune -af || true

echo "Building docker image locally..."
docker build -t "${IMAGE_NAME}:latest" .

echo "Starting new container..."
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