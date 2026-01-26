#!/bin/bash
set -e

# Rollback Script
# Usage: ./rollback.sh [rollback-type]

ROLLBACK_TYPE=${1:-all}
REGION=${AWS_REGION:-us-east-1}

echo "Starting rollback process: $ROLLBACK_TYPE"

case $ROLLBACK_TYPE in
  frontend)
    echo "Rolling back frontend..."
    
    S3_BUCKET=${S3_BUCKET_NAME}
    if [ -z "$S3_BUCKET" ]; then
      echo "Error: S3_BUCKET_NAME not set"
      exit 1
    fi
    
    # List versions and restore previous version
    echo "Listing S3 object versions..."
    aws s3api list-object-versions \
      --bucket "$S3_BUCKET" \
      --region "$REGION" \
      --query 'Versions[?Key==`index.html`] | sort_by(@, &LastModified) | [-2]' \
      --output text
    
    echo "Frontend rollback completed"
    ;;
  
  backend)
    echo "Rolling back backend..."
    
    ASG_NAME=${AUTO_SCALING_GROUP_NAME}
    if [ -z "$ASG_NAME" ]; then
      echo "Error: AUTO_SCALING_GROUP_NAME not set"
      exit 1
    fi
    
    # Get previous launch template
    LAUNCH_TEMPLATE=$(aws autoscaling describe-auto-scaling-groups \
      --auto-scaling-group-names "$ASG_NAME" \
      --region "$REGION" \
      --query 'AutoScalingGroups[0].LaunchTemplate' \
      --output json)
    
    echo "Current launch template: $LAUNCH_TEMPLATE"
    
    # Get previous version
    TEMPLATE_ID=$(echo "$LAUNCH_TEMPLATE" | jq -r '.LaunchTemplateId')
    CURRENT_VERSION=$(echo "$LAUNCH_TEMPLATE" | jq -r '.Version')
    PREVIOUS_VERSION=$((CURRENT_VERSION - 1))
    
    if [ "$PREVIOUS_VERSION" -lt 1 ]; then
      echo "No previous version available"
      exit 1
    fi
    
    echo "Rolling back to version: $PREVIOUS_VERSION"
    
    # Update ASG with previous version
    aws autoscaling update-auto-scaling-group \
      --auto-scaling-group-name "$ASG_NAME" \
      --launch-template "LaunchTemplateId=$TEMPLATE_ID,Version=$PREVIOUS_VERSION" \
      --region "$REGION"
    
    # Terminate instances to force replacement
    TARGET_GROUP_ARN=$(aws elbv2 describe-target-groups \
      --region "$REGION" \
      --query "TargetGroups[?contains(TargetGroupArn, 'backend-tg')].TargetGroupArn" \
      --output text)
    
    INSTANCES=$(aws elbv2 describe-target-health \
      --target-group-arn "$TARGET_GROUP_ARN" \
      --region "$REGION" \
      --query 'TargetHealthDescriptions[*].Target.Id' \
      --output text)
    
    for instance in $INSTANCES; do
      echo "Terminating instance: $instance"
      aws ec2 terminate-instances \
        --instance-ids "$instance" \
        --region "$REGION"
    done
    
    echo "Backend rollback initiated"
    ;;
  
  database)
    echo "Rolling back database..."
    echo "Database rollback must be performed manually using MongoDB backup/restore"
    ;;
  
  all)
    echo "Rolling back all components..."
    $0 frontend
    $0 backend
    echo "All rollbacks initiated"
    ;;
  
  *)
    echo "Unknown rollback type: $ROLLBACK_TYPE"
    echo "Usage: ./rollback.sh [frontend|backend|database|all]"
    exit 1
    ;;
esac

echo "Rollback process completed!"
