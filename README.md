# StartTech Application Repository

This repository contains the frontend and backend applications for the StartTech platform. It includes complete CI/CD pipelines, deployment automation, and comprehensive documentation for application development and deployment.

## Table of Contents

- [Overview](#overview)
- [Quick Start](#quick-start)
- [Repository Structure](#repository-structure)
- [Frontend Application](#frontend-application)
- [Backend Application](#backend-application)
- [CI/CD Pipelines](#cicd-pipelines)
- [Deployment](#deployment)
- [Local Development](#local-development)
- [Testing](#testing)
- [Troubleshooting](#troubleshooting)

## Overview

This application repository provides:

- **Modern Frontend** built with React and TypeScript
- **RESTful API Backend** built with Go
- **Automated CI/CD** via GitHub Actions
- **Container Deployment** with Docker
- **Health Monitoring** and readiness checks
- **Comprehensive Testing** frameworks
- **Production Deployment** automation

### Tech Stack

| Component | Technology | Version |
|-----------|-----------|---------|
| **Frontend** | React | 18+ |
| **Frontend Language** | TypeScript | 5.0+ |
| **Frontend Build** | Vite | 4+ |
| **Backend** | Go | 1.20+ |
| **Container Runtime** | Docker | 20.10+ |
| **CI/CD** | GitHub Actions | Native |
| **Deployment** | Bash Scripts | 4+ |
| **Package Manager (Frontend)** | npm | 8+ |
| **Package Manager (Backend)** | Go Modules | Native |

## Quick Start

### Frontend Setup

```bash
cd frontend
npm install
npm run dev
```

Access at `http://localhost:5173`

### Backend Setup

```bash
cd backend/MuchToDo
go mod download
go run cmd/api/main.go
```

Server runs on `http://localhost:8080`

### Docker Setup

```bash
# Build images
docker build -t starttech-frontend:latest frontend/
docker build -t starttech-backend:latest backend/MuchToDo/

# Run containers
docker run -p 3000:3000 starttech-frontend:latest
docker run -p 8080:8080 starttech-backend:latest
```

## Repository Structure

```
starttech-application/
├── .github/
│   └── workflows/
│       ├── frontend-ci-cd.yml           # Frontend pipeline
│       └── backend-ci-cd.yml            # Backend pipeline
├── frontend/
│   ├── public/                          # Static assets
│   ├── src/
│   │   ├── components/                  # React components
│   │   ├── context/                     # Context providers
│   │   ├── hooks/                       # Custom hooks
│   │   ├── lib/                         # Utilities
│   │   ├── routes/                      # Page components
│   │   ├── types/                       # TypeScript types
│   │   ├── App.tsx                      # Root component
│   │   ├── main.tsx                     # Entry point
│   │   └── index.css                    # Global styles
│   ├── package.json                     # Dependencies
│   ├── tsconfig.json                    # TypeScript config
│   ├── vite.config.ts                   # Vite config
│   └── README.md                        # Frontend docs
├── backend/
│   ├── README.md                        # Backend overview
│   └── MuchToDo/
│       ├── .dockerignore                # Docker ignore rules
│       ├── .env.example                 # Sample env file
│       ├── cmd/
│       │   └── api/
│       │       └── main.go              # Entry point
│       ├── internal/
│       │   ├── auth/                    # Authentication
│       │   ├── cache/                   # Caching logic
│       │   ├── config/                  # Configuration
│       │   ├── database/                # Database layer
│       │   ├── handlers/                # HTTP handlers
│       │   ├── logger/                  # Logging
│       │   ├── middleware/              # HTTP middleware
│       │   ├── models/                  # Data models
│       │   └── routes/                  # Route definitions
│       ├── go.mod                       # Go dependencies
│       ├── go.sum                       # Dependency lock
│       ├── docker-compose.yaml          # Local orchestration
│       ├── Dockerfile                   # Docker image
│       ├── Makefile                     # Build commands
│       └── docs/                        # Backend docs
├── evidence/                            # Deployment evidence artifacts
├── scripts/
│   ├── deploy-frontend.sh               # Frontend deployment
│   ├── deploy-backend.sh                # Backend deployment
│   ├── health-check.sh                  # Health verification
│   └── rollback.sh                      # Rollback utility
├── README.md                            # This file
└── .gitignore                           # Git ignore rules
```

## Frontend Application

### Overview

React-based single-page application with TypeScript for type safety.

**Features:**
- Component-based architecture
- Context API for state management
- TypeScript for type safety
- Responsive design
- REST API integration
- Authentication support
- Route-based code splitting

### Frontend Stack

- **Framework**: React 18+
- **Language**: TypeScript 5+
- **Build Tool**: Vite
- **Styling**: CSS Modules
- **State Management**: Context API
- **HTTP Client**: Fetch API / Axios

### Available Scripts

```bash
# Start development server
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview

# Run tests
npm run test

# Lint code
npm run lint

# Format code
npm run format
```

### Key Directories

| Directory | Purpose |
|-----------|---------|
| `src/components` | Reusable React components |
| `src/context` | State management with Context API |
| `src/hooks` | Custom React hooks |
| `src/lib` | Utility functions and helpers |
| `src/routes` | Page components and routing |
| `src/types` | TypeScript type definitions |
| `public` | Static assets (images, fonts, etc.) |

### Environment Variables

Create `.env.local`:

```env
VITE_API_URL=http://localhost:8080
VITE_APP_NAME=StartTech
VITE_ENVIRONMENT=development
```

### Frontend Architecture

```
App (Root)
├── AuthContext (Auth State)
├── Router
│   ├── Home Page
│   ├── Login Page
│   ├── Register Page
│   ├── Profile Page
│   ├── Todos Page
│   └── Settings Page
└── Global Styles
```

## Backend Application

### Overview

Go-based RESTful API with modular architecture and comprehensive middleware.

**Features:**
- RESTful API design
- JWT authentication
- Database integration (MongoDB)
- Redis caching
- Comprehensive logging
- Error handling middleware
- Health checks
- Docker deployment

### Backend Stack

- **Language**: Go 1.20+
- **Framework**: Go standard library (minimal dependencies)
- **Database**: MongoDB
- **Cache**: Redis
- **Authentication**: JWT
- **Container**: Docker
- **Build Tool**: Make

### Available Make Commands

```bash
make help                  # Show all commands
make build                 # Build binary
make run                   # Run application
make test                  # Run tests
make test-coverage        # Generate coverage report
make lint                  # Run linter
make format               # Format code
make docker-build         # Build Docker image
make docker-run           # Run Docker container
make docker-push          # Push to registry
```

### Key Directories

| Directory | Purpose |
|-----------|---------|
| `cmd/api` | Application entry point |
| `internal/auth` | Authentication logic |
| `internal/cache` | Redis caching layer |
| `internal/config` | Configuration management |
| `internal/database` | Database operations |
| `internal/handlers` | HTTP request handlers |
| `internal/logger` | Structured logging |
| `internal/middleware` | HTTP middleware |
| `internal/models` | Data models |
| `internal/routes` | Route definitions |

### Environment Variables

```env
SERVER_PORT=8080
SERVER_HOST=0.0.0.0
DATABASE_URL=mongodb://localhost:27017/starttech
REDIS_URL=redis://localhost:6379
JWT_SECRET=your-secret-key
LOG_LEVEL=info
ENVIRONMENT=development
```

### API Endpoints

```
POST   /api/auth/register        # User registration
POST   /api/auth/login           # User login
POST   /api/auth/refresh         # Token refresh
POST   /api/auth/logout          # User logout

GET    /api/todos                # List todos
POST   /api/todos                # Create todo
GET    /api/todos/:id            # Get todo
PUT    /api/todos/:id            # Update todo
DELETE /api/todos/:id            # Delete todo

GET    /api/users/profile        # Get user profile
PUT    /api/users/profile        # Update profile
POST   /api/users/change-password # Change password

GET    /health                   # Health check
GET    /metrics                  # Prometheus metrics
```

## CI/CD Pipelines

### Frontend CI/CD Pipeline

**Triggers:** Push to main, pull requests, manual dispatch

**Stages:**
1. **Install** - Install dependencies
2. **Lint** - Run ESLint
3. **Build** - Build production bundle
4. **Test** - Run test suite
5. **Security Scan** - OWASP/Snyk scan
6. **Deploy** - Deploy to S3/CloudFront
7. **Smoke Tests** - Verify deployment

**See:** [`.github/workflows/frontend-ci-cd.yml`](.github/workflows/frontend-ci-cd.yml)

### Backend CI/CD Pipeline

**Triggers:** Push to main, pull requests, manual dispatch

**Stages:**
1. **Setup** - Install Go dependencies
2. **Lint** - Run golangci-lint
3. **Build** - Compile Go binary
4. **Test** - Run test suite with coverage
5. **SAST** - Static application security testing
6. **Build Docker** - Create container image
7. **Scan Image** - Scan for vulnerabilities
8. **Push to ECR** - Push image to AWS ECR
9. **Deploy to ECS** - Deploy new version
10. **Health Check** - Verify deployment

**See:** [`.github/workflows/backend-ci-cd.yml`](.github/workflows/backend-ci-cd.yml)

## Deployment

### Prerequisites

- AWS account with ECR and ECS access
- Docker credentials configured
- GitHub secrets configured (AWS credentials, etc.)

### Automated Deployment

Deployments happen automatically on push to main via GitHub Actions.

### Manual Deployment

#### Frontend Deployment

```bash
./scripts/deploy-frontend.sh
```

**What it does:**
- Builds React application
- Uploads to S3
- Invalidates CloudFront cache
- Verifies deployment

#### Backend Deployment

```bash
./scripts/deploy-backend.sh
```

**What it does:**
- Builds Docker image
- Pushes to ECR
- Updates ECS service
- Waits for service stability
- Performs health checks

#### Health Checks

```bash
./scripts/health-check.sh
```

Verifies:
- API responsiveness
- Database connectivity
- Cache availability
- Authentication system
- Critical endpoints

#### Rollback

```bash
./scripts/rollback.sh <version>
```

Rolls back to previous version in case of issues.

## Local Development

### Prerequisites

- Node.js 16+
- Go 1.20+
- Docker & Docker Compose
- Git
- Make (for backend)

### Setup Development Environment

```bash
# Clone repository
git clone https://github.com/starttech/application.git
cd application

# Setup frontend
cd frontend
npm install
npm run dev

# In another terminal, setup backend
cd backend/MuchToDo
go mod download
go run cmd/api/main.go
```

### Docker Compose Setup

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

## Testing

### Frontend Testing

```bash
cd frontend

# Run all tests
npm test

# Run tests in watch mode
npm test -- --watch

# Generate coverage report
npm test -- --coverage

# Run specific test file
npm test -- TodoItem.test.tsx
```

### Backend Testing

```bash
cd backend/MuchToDo

# Run all tests
make test

# Run with coverage
make test-coverage

# Run specific test
go test ./internal/handlers -v

# Run with race detector
go test -race ./...
```

## Troubleshooting

### Frontend Issues

#### Port Already in Use

```bash
# Find process using port 5173
lsof -i :5173

# Kill process
kill -9 <PID>

# Or use different port
npm run dev -- --port 3001
```

#### Build Failures

```bash
# Clear node_modules and reinstall
rm -rf node_modules package-lock.json
npm install

# Clear Vite cache
rm -rf dist .vite
npm run build
```

#### API Connection Issues

1. Verify backend is running: `curl http://localhost:8080/health`
2. Check `.env.local` has correct API_URL
3. Check browser console for CORS errors
4. Verify authentication token is valid

### Backend Issues

#### Database Connection

```bash
# Check MongoDB connection
go run ./cmd/api -v

# Verify MongoDB is running
docker ps | grep mongo

# Check logs
docker logs mongo
```

#### Redis Connection

```bash
# Test Redis connection
redis-cli ping

# Check Redis running
docker ps | grep redis
```

#### Build Failures

```bash
# Clean build
rm -f starttech-api

# Rebuild
make clean build

# Run with verbose output
go run ./cmd/api -v
```

#### Docker Issues

```bash
# Build image with verbose output
docker build --progress=plain -t starttech-backend:latest .

# Run with logs
docker run -it --rm starttech-backend:latest

# Debug container
docker run -it --rm --entrypoint bash starttech-backend:latest
```

### Deployment Issues

#### Frontend Deployment

```bash
# Check S3 bucket
aws s3 ls s3://starttech-frontend-assets

# Verify CloudFront
aws cloudfront list-distributions

# Check logs
tail -f /var/log/starttech-frontend-deploy.log
```

#### Backend Deployment

```bash
# Check ECS service
aws ecs describe-services --cluster starttech --services starttech-api

# View task logs
aws logs tail /ecs/starttech-api --follow

# Check ECR repository
aws ecr describe-repositories

# View image tags
aws ecr list-images --repository-name starttech-backend
```

## Environment Variables

### Frontend

| Variable | Default | Description |
|----------|---------|-------------|
| `VITE_API_URL` | - | Backend API base URL |
| `VITE_APP_NAME` | StartTech | Application name |
| `VITE_ENVIRONMENT` | development | Environment name |
| `VITE_LOG_LEVEL` | info | Logging level |

### Backend

| Variable | Default | Description |
|----------|---------|-------------|
| `SERVER_PORT` | 8080 | Server port |
| `SERVER_HOST` | 0.0.0.0 | Server host |
| `DATABASE_URL` | - | MongoDB connection string |
| `REDIS_URL` | - | Redis connection string |
| `JWT_SECRET` | - | JWT signing secret |
| `LOG_LEVEL` | info | Logging level |
| `ENVIRONMENT` | development | Environment name |

## Security

### Frontend Security

- Environment variables for sensitive data
- HTTPS-only in production
- Content Security Policy headers
- CORS configuration
- Input validation and sanitization
- Secure session handling

### Backend Security

- JWT token-based authentication
- Password hashing with bcrypt
- Input validation and sanitization
- Rate limiting on API endpoints
- CORS configuration
- Security headers (HSTS, X-Frame-Options, etc.)
- Encryption for sensitive data

## Contributing

1. Create feature branch: `git checkout -b feature/your-feature`
2. Make changes and commit: `git commit -m "Add feature"`
3. Push to branch: `git push origin feature/your-feature`
4. Create pull request
5. Tests must pass and code reviewed
6. Merge and auto-deploy to staging/production

## Additional Resources

- [React Documentation](https://react.dev)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)
- [Vite Documentation](https://vitejs.dev)
- [Go by Example](https://gobyexample.com)
- [Go Standard Library](https://pkg.go.dev/std)

## Support

For issues or questions:
1. Check troubleshooting section above
2. Review logs with `docker logs` or `npm run dev`
3. Check GitHub Actions workflow runs
4. Create an issue with detailed error messages

---

**Last Updated**: 2024  
**Node Version**: 18+  
**Go Version**: 1.20+  
**Docker Version**: 20.10+
