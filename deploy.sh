#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting deployment process...${NC}"

# Check if .env file exists
if [ ! -f .env ]; then
    echo -e "${RED}Error: .env file not found${NC}"
    exit 1
fi

# Load environment variables from .env file
export $(cat .env | grep -v '^#' | xargs)

# Check if required variables are set
if [ -z "$BIG_QUERY_PROJECT" ]; then
    echo -e "${RED}Error: BIG_QUERY_PROJECT not set in .env file${NC}"
    exit 1
fi

# Set configuration variables
PROJECT_ID=$BIG_QUERY_PROJECT
REGION=${REGION:-"us-central1"}  # Default to us-central1 if not specified in .env
SERVICE_NAME="vanna-ai-demo"
IMAGE_NAME="vanna-ai-demo"

echo -e "${GREEN}Using configuration:${NC}"
echo "Project ID: $PROJECT_ID"
echo "Region: $REGION"
echo "Service Name: $SERVICE_NAME"
echo "Image Name: $IMAGE_NAME"

# Enable required APIs
echo -e "${GREEN}Enabling required APIs...${NC}"
gcloud services enable \
    cloudbuild.googleapis.com \
    run.googleapis.com

# Build the Docker image
echo -e "${GREEN}Building Docker image...${NC}"
docker build -t $IMAGE_NAME .

docker tag $IMAGE_NAME gcr.io/$PROJECT_ID/$IMAGE_NAME

# Configure Docker to use gcloud as a credential helper
echo -e "${GREEN}Configuring Docker authentication...${NC}"
gcloud auth configure-docker

# Push the image to Google Container Registry
echo -e "${GREEN}Pushing image to Container Registry...${NC}"
docker push gcr.io/$PROJECT_ID/$IMAGE_NAME

# Deploy to Cloud Run
echo -e "${GREEN}Deploying to Cloud Run...${NC}"
gcloud run deploy $SERVICE_NAME \
    --image gcr.io/$PROJECT_ID/$IMAGE_NAME \
    --region $REGION \
    --allow-unauthenticated \
    --cpu=1 \
    --memory=2Gi \
    --min-instances=0 \
    --max-instances=1 \
    --port=8084 \
    --set-env-vars="$(cat .env | grep -v '^#' | xargs)"

# Get the service URL
SERVICE_URL=$(gcloud run services describe $SERVICE_NAME --platform managed --region $REGION --format 'value(status.url)')

echo -e "${GREEN}Deployment completed successfully!${NC}"
echo -e "Service URL: ${SERVICE_URL}"

# Optional: Open the service URL in the default browser
if command -v xdg-open &> /dev/null; then
    xdg-open $SERVICE_URL
elif command -v open &> /dev/null; then
    open $SERVICE_URL
fi