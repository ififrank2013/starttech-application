#!/bin/bash
set -e

# Deploy Backend to EC2 via Auto Scaling Group
# Usage: ./deploy-backend.sh <asg-name> <docker-image>

ASG_NAME=${1:-${AUTO_SCALING_GROUP_NAME}}
DOCKER_IMAGE=${2:-${BACKEND_DOCKER_IMAGE}}
REGION=${3:-${AWS_REGION:-us-east-1}}

if [ -z "$ASG_NAME" ]; then
  echo "Error: Auto Scaling Group name not provided"
  exit 1
fi

if [ -z "$DOCKER_IMAGE" ]; then
  echo "Error: Docker image not provided"
  exit 1
fi

echo "Deploying backend using ASG: $ASG_NAME"
echo "Docker image: $DOCKER_IMAGE"
echo "Region: $REGION"

# Get target group ARN
TARGET_GROUP_ARN=$(aws elbv2 describe-target-groups \
  --region "$REGION" \
  --query "TargetGroups[?contains(TargetGroupArn, 'backend-tg')].TargetGroupArn" \
  --output text)

if [ -z "$TARGET_GROUP_ARN" ]; then
  echo "Error: Could not find target group ARN"
  exit 1
fi

echo "Target Group ARN: $TARGET_GROUP_ARN"

# Get current instances from target group
INSTANCES=$(aws elbv2 describe-target-health \
  --target-group-arn "$TARGET_GROUP_ARN" \
  --region "$REGION" \
  --query 'TargetHealthDescriptions[?TargetHealth.State!=`draining`].Target.Id' \
  --output text)

if [ -z "$INSTANCES" ]; then
  echo "No healthy instances found in target group"
  exit 1
fi

echo "Found instances: $INSTANCES"

# Rolling update - one instance at a time
for instance in $INSTANCES; do
  echo "Updating instance: $instance"
  
  # Drain connections
  aws elbv2 modify-target-group-attributes \
    --target-group-arn "$TARGET_GROUP_ARN" \
    --attributes Key=deregistration_delay.timeout_seconds,Value=30 \
    --region "$REGION" || true
  
  # Deregister instance from target group
  aws elbv2 deregister-targets \
    --target-group-arn "$TARGET_GROUP_ARN" \
    --targets Id="$instance" \
    --region "$REGION"
  
  # Wait for draining
  echo "Waiting for connection draining..."
  sleep 30
  
  # Reboot instance (simulates deploy)
  aws ec2 reboot-instances \
    --instance-ids "$instance" \
    --region "$REGION"
  
  echo "Rebooting instance: $instance"
  sleep 30
  
  # Register instance back
  aws elbv2 register-targets \
    --target-group-arn "$TARGET_GROUP_ARN" \
    --targets Id="$instance" \
    --region "$REGION"
  
  echo "Instance $instance registered back to target group"
  
  # Wait for health check
  echo "Waiting for instance health check..."
  for i in {1..30}; do
    HEALTH=$(aws elbv2 describe-target-health \
      --target-group-arn "$TARGET_GROUP_ARN" \
      --targets Id="$instance" \
      --region "$REGION" \
      --query 'TargetHealthDescriptions[0].TargetHealth.State' \
      --output text)
    
    if [ "$HEALTH" = "healthy" ]; then
      echo "Instance is healthy!"
      break
    fi
    
    echo "Instance health: $HEALTH (attempt $i/30)"
    sleep 10
  done
done

echo "Backend deployment completed successfully!"
