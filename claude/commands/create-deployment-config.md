# .claude/create-deployment-config

Generate deployment and infrastructure patterns reference covering CI/CD pipelines, environment configuration, containerization, and deployment strategies.

## Usage

```bash
claude < .claude/create-deployment-config
```

## File Management

**Output Location**: `docs/codebase_ref/deployment_config.md`

**Before Starting**: I will check if `docs/codebase_ref/deployment_config.md` already exists and assess whether it needs updating based on:
- Recent changes to CI/CD configuration files
- Updates to Docker or containerization setup
- Changes to deployment scripts or infrastructure code
- New environment configurations or secrets management
- Updates to monitoring, logging, or observability setup

**Update Decision Process**:
1. **If file doesn't exist**: Create new comprehensive reference
2. **If file exists**: 
   - Read existing file and analyze timestamp/metadata
   - Check recent commits for deployment-related changes
   - Compare current deployment patterns with documented patterns
   - Ask whether you want to:
     - **Update**: Refresh specific sections while preserving structure
     - **Append**: Add new patterns for new deployment features
     - **Regenerate**: Create completely fresh file
     - **Skip**: Keep existing file unchanged

## What This Command Creates

A `deployment_config.md` file with:

### Section 1: Environment Configuration
- **Environment Variables** - Configuration management across development, staging, production
- **Secrets Management** - API keys, database credentials, sensitive configuration
- **Configuration Files** - Environment-specific settings and overrides
- **Feature Flags** - Runtime configuration and feature toggles

### Section 2: Containerization
- **Docker Configuration** - Dockerfile patterns, multi-stage builds, optimization
- **Docker Compose** - Local development and testing environments
- **Container Registry** - Image building, tagging, and distribution
- **Container Security** - Best practices for secure container images

### Section 3: CI/CD Pipelines
- **Build Processes** - Automated building, testing, and packaging
- **Deployment Strategies** - Rolling deployments, blue-green, canary releases
- **Pipeline Configuration** - GitHub Actions, GitLab CI, Jenkins patterns
- **Quality Gates** - Testing, security scanning, code quality checks

### Section 4: Infrastructure
- **Server Configuration** - Production server setup and management
- **Database Deployment** - Migration strategies, backup and recovery
- **Load Balancing** - Traffic distribution and high availability
- **CDN and Static Assets** - Content delivery and asset management

### Section 5: Monitoring & Observability
- **Logging Configuration** - Structured logging, log aggregation
- **Metrics Collection** - Application and infrastructure monitoring
- **Health Checks** - Service health monitoring and alerting
- **Error Tracking** - Exception monitoring and debugging

### Section 6: Security & Compliance
- **SSL/TLS Configuration** - Certificate management and HTTPS setup
- **Access Control** - Authentication, authorization, and permissions
- **Security Scanning** - Vulnerability assessment and compliance
- **Backup Strategies** - Data protection and disaster recovery

## Process

I'll analyze your deployment setup to extract patterns by:

1. **File Existence Check** - Assess if update is needed based on recent deployment changes
2. **Infrastructure Discovery** - Find all deployment and infrastructure configuration files
3. **CI/CD Analysis** - Examine pipeline configurations and deployment workflows
4. **Environment Pattern Extraction** - Identify configuration and secrets management patterns
5. **Container Analysis** - Document containerization and orchestration approaches
6. **Monitoring Pattern Review** - Analyze observability and monitoring setup
7. **Documentation Generation** - Create reference with concrete examples and file locations

## Commands Used

```bash
# Check existing file and recent deployment changes
ls -la docs/codebase_ref/deployment_config.md
git log --oneline -20 --name-only | rg "(deploy|docker|ci|cd|infra|k8s)"

# Infrastructure and deployment files discovery
fd -g "Dockerfile*" -g "docker-compose*" -g "*.dockerfile" | head -10
fd -g ".github" -g ".gitlab-ci*" -g "Jenkinsfile" -g "azure-pipelines*" | head -10
fd -g "terraform" -g "ansible" -g "k8s" -g "kubernetes" -t d | head -10
fd -g "*.yml" -g "*.yaml" | rg "(deploy|ci|cd|k8s|helm)" | head -15

# Environment and configuration
fd -g ".env*" -g "config*" -g "settings*" | head -15
rg "getenv|environ|os\.environ" --type py -n | head -15
rg "SECRET|API_KEY|PASSWORD|TOKEN" --type py -n | head -10
fd -g "secrets*" -g "vault*" -g "*.enc" | head -10

# Docker and containerization patterns
fd -g "Dockerfile*" -x head -20 {}
fd -g "docker-compose*" -x head -25 {}
rg "FROM |RUN |COPY |ENV |EXPOSE" Dockerfile* | head -20
rg "image:|ports:|volumes:|environment:" docker-compose* -A 2 | head -20

# CI/CD pipeline patterns
fd -g ".github/workflows" -x fd -g "*.yml" -x head -30 {}
fd -g ".gitlab-ci.yml" -x head -30 {}
rg "jobs:|steps:|stage:|script:" -A 3 | head -20
rg "build|test|deploy|release" .github/ .gitlab-ci* -A 2 | head -15

# Infrastructure as code
fd -g "*.tf" -x head -15 {} | head -20
fd -g "*.yml" -g "*.yaml" | rg "k8s|kubernetes" -x head -20 {}
rg "resource|provider|module" --type terraform -n -A 3 | head -15
rg "apiVersion|kind:|metadata:" --type yaml -n -A 3 | head -15

# Monitoring and logging
rg "logging|logger|log_level|sentry|datadog|prometheus" --type py -n -A 2 | head -15
fd -g "*monitor*" -g "*observability*" -g "*logging*" | head -10
rg "health.*check|/health|/status|/ping" --type py -n -A 2 | head -10

# Security and SSL
rg "ssl|tls|certificate|https|security" -i -A 2 | head -15
fd -g "*.pem" -g "*.crt" -g "*.key" | head -10
rg "cors|csrf|helmet|security.*headers" --type py -n -A 2 | head -10

# Deployment scripts and automation
fd -g "deploy*" -g "release*" -g "build*" -g "setup*" -e sh -e py | head -15
rg "#!/bin/bash|#!/usr/bin/env python" -A 10 | head -20
fd -g "Makefile" -g "justfile" -x rg "deploy|build|release" {} -A 2

# Database deployment and migrations
rg "migration|migrate|alembic|flyway" --type py -n -A 2 | head -10
fd -g "*migration*" -g "*migrate*" | head -10
rg "backup|restore|dump|pg_dump" -A 2 | head -10
```

## Output Format

The generated `deployment_config.md` will include:

```markdown
<!-- Generated: YYYY-MM-DD HH:MM:SS UTC -->
<!-- Platform: AWS/GCP/Azure/On-Premise -->
<!-- Container: Docker/Podman -->
<!-- CI/CD: GitHub Actions/GitLab CI/Jenkins -->

# Deployment Configuration Reference

## Environment Configuration

### Environment Variables
From `.env.example` and `src/config/settings.py`:
```bash
# Database
DATABASE_URL=postgresql://user:pass@localhost:5432/dbname
REDIS_URL=redis://localhost:6379/0

# External Services
API_SECRET_KEY=your-secret-key-here
EMAIL_SERVICE_API_KEY=your-email-api-key

# Application Settings
DEBUG=false
LOG_LEVEL=info
ENVIRONMENT=production
```

### Configuration Management
From `src/config/settings.py` L15-30:
```python
class Settings(BaseSettings):
    database_url: str = Field(..., env="DATABASE_URL")
    secret_key: str = Field(..., env="SECRET_KEY")
    debug: bool = Field(False, env="DEBUG")
    log_level: str = Field("info", env="LOG_LEVEL")
    
    class Config:
        env_file = ".env"
        case_sensitive = False
```

## Containerization

### Dockerfile Pattern
From `Dockerfile` L1-25:
```dockerfile
FROM python:3.11-slim as base

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Create app user
RUN useradd --create-home --shell /bin/bash app
WORKDIR /home/app

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY --chown=app:app . .

# Switch to app user
USER app

EXPOSE 8000
CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

### Docker Compose Configuration
From `docker-compose.yml` L1-35:
```yaml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=postgresql://postgres:password@db:5432/appdb
      - REDIS_URL=redis://redis:6379/0
    depends_on:
      - db
      - redis
    volumes:
      - ./logs:/home/app/logs

  db:
    image: postgres:15
    environment:
      POSTGRES_DB: appdb
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

volumes:
  postgres_data:
```

## CI/CD Pipelines

### GitHub Actions Workflow
From `.github/workflows/deploy.yml` L1-40:
```yaml
name: Deploy to Production

on:
  push:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'
      
      - name: Install dependencies
        run: |
          pip install -r requirements.txt
          pip install -r requirements-dev.txt
      
      - name: Run tests
        run: |
          pytest --cov=src --cov-report=xml
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3

  deploy:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      
      - name: Build and push Docker image
        run: |
          docker build -t myapp:${{ github.sha }} .
          docker tag myapp:${{ github.sha }} myapp:latest
          docker push myapp:latest
      
      - name: Deploy to production
        run: |
          # Deployment commands here
```

## Infrastructure Patterns

### Kubernetes Deployment
From `k8s/deployment.yml` L1-30:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp-deployment
  labels:
    app: myapp
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: myapp
        image: myapp:latest
        ports:
        - containerPort: 8000
        env:
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: db-secret
              key: url
        livenessProbe:
          httpGet:
            path: /health
            port: 8000
          initialDelaySeconds: 30
          periodSeconds: 10
```

## Monitoring & Observability

### Health Check Implementation
From `src/api/health.py` L10-25:
```python
@router.get("/health")
async def health_check():
    """Health check endpoint for load balancer."""
    try:
        # Check database connection
        db_status = await check_database_connection()
        
        # Check external services
        redis_status = await check_redis_connection()
        
        return {
            "status": "healthy",
            "timestamp": datetime.utcnow().isoformat(),
            "services": {
                "database": db_status,
                "redis": redis_status
            }
        }
    except Exception as e:
        raise HTTPException(status_code=503, detail=f"Health check failed: {str(e)}")
```

### Logging Configuration
From `src/config/logging.py` L10-25:
```python
LOGGING_CONFIG = {
    "version": 1,
    "disable_existing_loggers": False,
    "formatters": {
        "default": {
            "format": "%(asctime)s - %(name)s - %(levelname)s - %(message)s",
        },
        "json": {
            "format": '{"timestamp": "%(asctime)s", "level": "%(levelname)s", "logger": "%(name)s", "message": "%(message)s"}',
        },
    },
    "handlers": {
        "console": {
            "class": "logging.StreamHandler",
            "formatter": "json" if settings.environment == "production" else "default",
        },
    },
    "root": {
        "level": settings.log_level.upper(),
        "handlers": ["console"],
    },
}
```

[Additional sections...]
```

## Evaluation Criteria

A successful deployment config reference should:

1. **Environment Consistency**: Clear patterns for configuration across all environments
2. **Security Best Practices**: Proper secrets management and security configurations
3. **Automation Coverage**: Complete CI/CD pipeline documentation with examples
4. **Monitoring Integration**: Comprehensive observability and health checking patterns
5. **Disaster Recovery**: Backup, recovery, and rollback procedures documented

## Maintenance Strategy

**Update Triggers**:
- Changes to CI/CD pipeline configuration
- Infrastructure updates or new deployment targets
- Security policy changes or compliance requirements
- New monitoring or observability tools
- Changes to containerization or orchestration setup

**Quick Staleness Check**:
```bash
# Check for recent deployment-related changes
git log --since="30 days ago" --name-only | rg "(deploy|docker|ci|infra)" | wc -l

# Verify current deployment files exist
fd -g "Dockerfile" -g "docker-compose*" -g ".github/workflows" | wc -l
```