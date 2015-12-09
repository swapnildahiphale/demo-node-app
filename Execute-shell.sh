#!/bin/bash
SERVICE_NAME="demo-node-app-service"
IMAGE_VERSION="v_"${BUILD_NUMBER}
TASK_FAMILY="demo-node-app"
CLUSTER_NAME="demo-cluster"

# Create a new task definition for this build
sed -e "s;%BUILD_NUMBER%;${BUILD_NUMBER};g" task-definition.json > task-definition:v_${BUILD_NUMBER}.json
aws ecs register-task-definition --cli-input-json file://task-definition:v_${BUILD_NUMBER}.json

# Update the service with the new task definition and desired count
TASK_REVISION=`aws ecs describe-task-definition --task-definition $TASK_FAMILY --region us-west-2 | egrep "revision" | tr "/" " " | awk '{print $2}' | sed 's/"$//'`

DESIRED_COUNT=`aws ecs describe-services --cluster $CLUSTER_NAME --services $SERVICE_NAME --region us-west-2 | egrep -m 1 "desiredCount" | tr "/" " " | awk '{print $2}' | sed 's/,$//'`

if [ ${DESIRED_COUNT} = "0" ]; then
    DESIRED_COUNT="1"
fi
aws ecs update-service --cluster ${CLUSTER_NAME} --service ${SERVICE_NAME} --task-definition ${TASK_FAMILY}:${TASK_REVISION} --desired-count ${DESIRED_COUNT} --region us-west-2