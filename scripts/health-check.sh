#!/bin/bash
set -e

# Health Check Script
# Usage: ./health-check.sh <alb-dns> [port]

ALB_DNS=${1:-${ALB_ENDPOINT}}
PORT=${2:-80}
TIMEOUT=${TIMEOUT:-300}
INTERVAL=${INTERVAL:-10}

if [ -z "$ALB_DNS" ]; then
  echo "Error: ALB DNS not provided"
  exit 1
fi

echo "Starting health check for: $ALB_DNS:$PORT"
echo "Timeout: $TIMEOUT seconds"
echo "Check interval: $INTERVAL seconds"

ELAPSED=0
FAILED_CHECKS=0
MAX_FAILURES=3

while [ $ELAPSED -lt $TIMEOUT ]; do
  # Check API health endpoint
  RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "http://$ALB_DNS:$PORT/health" || echo "000")
  
  echo "[$ELAPSED/$TIMEOUT] Health check response: $RESPONSE"
  
  if [ "$RESPONSE" = "200" ]; then
    echo "✓ API health check passed"
    FAILED_CHECKS=0
  else
    FAILED_CHECKS=$((FAILED_CHECKS + 1))
    echo "✗ API health check failed (attempt $FAILED_CHECKS/$MAX_FAILURES)"
    
    if [ $FAILED_CHECKS -ge $MAX_FAILURES ]; then
      echo "Health check failed after $MAX_FAILURES attempts"
      exit 1
    fi
  fi
  
  # Check database connectivity
  if command -v mongo &> /dev/null; then
    echo "Checking database connectivity..."
    if mongo --eval "db.adminCommand('ping')" &> /dev/null; then
      echo "✓ Database connectivity OK"
    else
      echo "✗ Database connectivity failed"
    fi
  fi
  
  # Check Redis connectivity
  if command -v redis-cli &> /dev/null; then
    echo "Checking Redis connectivity..."
    if redis-cli ping &> /dev/null; then
      echo "✓ Redis connectivity OK"
    else
      echo "✗ Redis connectivity failed"
    fi
  fi
  
  ELAPSED=$((ELAPSED + INTERVAL))
  sleep $INTERVAL
done

echo "✓ Health check completed successfully!"
exit 0
