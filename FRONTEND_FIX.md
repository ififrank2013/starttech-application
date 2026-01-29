# Frontend API Configuration Fix

## Issue
The deployed frontend was trying to connect to `localhost:8080` instead of the production backend ALB.

## Root Cause
The frontend was built without the `VITE_API_BASE_URL` environment variable, causing it to default to localhost.

## Solution Applied

### 1. Created .env File
Created `/frontend/.env` with:
```
VITE_API_BASE_URL=http://prod-alb-882874161.us-east-1.elb.amazonaws.com
```

### 2. Rebuilt Frontend
```bash
npm run build
```
The build now includes the correct backend URL in the compiled JavaScript.

### 3. Redeployed to S3
```bash
aws s3 sync dist/ s3://prod-frontend-197104194412/ --delete --cache-control 'public, max-age=31536000' --exclude 'index.html'
aws s3 cp dist/index.html s3://prod-frontend-197104194412/index.html --cache-control 'public, max-age=0, must-revalidate' --content-type 'text/html'
```

### 4. Invalidated CloudFront Cache
```bash
aws cloudfront create-invalidation --distribution-id E2E3XA2QGW051S --paths '/*'
```
Invalidation ID: `I31Z6OSROXM7NZNRBFQYP2CT81`

## Verification
The updated frontend should now:
- Connect to `http://prod-alb-882874161.us-east-1.elb.amazonaws.com` for API calls
- Allow user registration without CORS errors
- Work correctly from `https://d22r27pmlhadif.cloudfront.net`

## Testing
Wait 2-3 minutes for CloudFront invalidation to complete, then:
1. Visit https://d22r27pmlhadif.cloudfront.net
2. Try to register a new user
3. The registration should now work correctly

## Next Steps for Future Deployments
Always ensure `.env` file exists with production values before building:
```bash
echo "VITE_API_BASE_URL=http://prod-alb-882874161.us-east-1.elb.amazonaws.com" > .env
npm run build
```

Or use environment variables in your CI/CD pipeline.
