# .claude/create-troubleshooting

Generate comprehensive troubleshooting and debugging patterns reference covering common issues, debugging approaches, and resolution strategies.

## Usage

```bash
claude < .claude/create-troubleshooting
```

## File Management

**Output Location**: `docs/codebase_ref/troubleshooting.md`

**Before Starting**: I will check if `docs/codebase_ref/troubleshooting.md` already exists and assess whether it needs updating based on:
- Recent error patterns or issues found in logs
- New debugging tools or approaches implemented
- Changes to error handling or logging configuration
- Updates to monitoring and alerting systems
- New common issues or resolution patterns discovered

**Update Decision Process**:
1. **If file doesn't exist**: Create new comprehensive reference
2. **If file exists**: 
   - Read existing file and analyze timestamp/metadata
   - Check recent commits for error handling or debugging changes
   - Review recent issues, bugs, or incident reports
   - Ask whether you want to:
     - **Update**: Add new troubleshooting scenarios and solutions
     - **Append**: Add new debugging tools or error patterns
     - **Regenerate**: Create completely fresh file
     - **Skip**: Keep existing file unchanged

## What This Command Creates

A `troubleshooting.md` file with:

### Section 1: Common Issues & Solutions
- **Application Startup Issues** - Configuration errors, dependency problems, port conflicts
- **Database Connection Problems** - Connection strings, authentication, network issues
- **API Response Issues** - Timeout errors, authentication failures, rate limiting
- **Performance Problems** - Slow queries, memory leaks, CPU bottlenecks

### Section 2: Error Patterns & Diagnosis
- **Exception Analysis** - Common exception types and their causes
- **Log Pattern Recognition** - Identifying issues from log messages
- **Error Code Mapping** - HTTP status codes, database errors, external service errors
- **Stack Trace Analysis** - Reading and interpreting error stack traces

### Section 3: Debugging Tools & Techniques
- **Local Debugging** - IDE debugging, print statements, logging levels
- **Production Debugging** - Log analysis, metrics review, distributed tracing
- **Database Debugging** - Query analysis, connection monitoring, transaction issues
- **Network Debugging** - API calls, external service integration, timeout analysis

### Section 4: Monitoring & Alerting
- **Error Detection** - Automated error detection and alerting
- **Performance Monitoring** - Response time, throughput, resource usage alerts
- **Health Check Monitoring** - Service availability and dependency monitoring
- **Log Aggregation** - Centralized logging and search patterns

### Section 5: Incident Response
- **Issue Triage** - Severity assessment and initial response
- **Root Cause Analysis** - Investigation techniques and documentation
- **Recovery Procedures** - Rollback strategies, service restoration
- **Post-Incident Review** - Learning and prevention strategies

### Section 6: Development Environment Issues
- **Setup Problems** - Environment configuration, dependency installation
- **Test Failures** - Test environment issues, fixture problems, mock failures
- **Build Issues** - Compilation errors, packaging problems, dependency conflicts
- **IDE and Tool Problems** - Configuration issues, extension problems

## Process

I'll analyze your codebase and infrastructure to extract troubleshooting patterns by:

1. **File Existence Check** - Assess if update is needed based on recent changes
2. **Error Pattern Discovery** - Find common error handling and exception patterns
3. **Log Analysis** - Examine logging patterns and common error messages
4. **Debugging Tool Review** - Document debugging configurations and tools used
5. **Monitoring Setup Analysis** - Review health checks, alerts, and monitoring patterns
6. **Issue History Review** - Analyze git history for common problem patterns
7. **Documentation Generation** - Create reference with concrete examples and resolution steps

## Commands Used

```bash
# Check existing file and recent troubleshooting changes
ls -la docs/codebase_ref/troubleshooting.md
git log --oneline -20 --name-only | rg "(fix|bug|error|debug|issue)"

# Error and exception patterns
rg "raise \w+Error|except \w+Error|Exception" --type py -n -A 2 | head -20
rg "HTTPException|ValidationError|DatabaseError|ConnectionError" --type py -n -A 3 | head -15
rg "try:|except:|finally:|raise" --type py -n -A 2 | head -20
rg "ERROR|CRITICAL|FATAL" --type py -n -A 1 | head -15

# Logging patterns and error messages
rg "logger\.|logging\.|log\." --type py -n -A 2 | head -20
rg "\.error\(|\.warning\(|\.critical\(|\.exception\(" --type py -n -A 2 | head -15
rg "\".*error.*\"|'.*error.*'" --type py -n | head -15
rg "status_code.*[45]\d\d|4\d\d|5\d\d" --type py -n -A 2 | head -10

# Debugging configurations and tools
fd -g "*debug*" -g "*trace*" -g "*profile*" | head -10
rg "debug|DEBUG|trace|TRACE|profile" --type py -n -A 2 | head -15
fd -g ".vscode" -g ".idea" -x fd -g "*.json" -x head -10 {}
rg "pdb|breakpoint|debugger|ipdb" --type py -n -A 2 | head -10

# Health checks and monitoring
rg "health.*check|/health|/status|/ping|alive" --type py -n -A 3 | head -15
rg "monitor|alert|metric|prometheus|grafana" --type py -n -A 2 | head -10
fd -g "*monitor*" -g "*health*" -g "*alert*" | head -10

# Configuration and environment issues
rg "getenv|environ|config.*error|missing.*config" --type py -n -A 2 | head -15
fd -g ".env*" -g "*config*" -x head -5 {} | head -20
rg "connection.*fail|timeout|refused|unreachable" --type py -n -A 2 | head -10

# Database issues and debugging
rg "database.*error|db.*error|sql.*error|migration.*error" --type py -n -A 3 | head -10
rg "connection.*pool|session.*error|transaction.*error" --type py -n -A 2 | head -10
rg "deadlock|constraint|foreign.*key|unique.*constraint" --type py -n -A 2 | head -5

# Performance and resource issues
rg "memory|cpu|slow|timeout|performance|bottleneck" --type py -n -A 2 | head -15
rg "cache.*miss|cache.*error|redis.*error" --type py -n -A 2 | head -10
rg "rate.*limit|throttle|quota.*exceeded" --type py -n -A 2 | head -10

# API and external service issues
rg "api.*error|service.*unavailable|external.*error" --type py -n -A 3 | head -10
rg "401|403|404|429|500|502|503|504" --type py -n -A 2 | head -15
rg "requests.*error|http.*error|client.*error" --type py -n -A 2 | head -10

# Common git issues and fixes
git log --grep="fix" --oneline -20
git log --grep="bug" --oneline -20
git log --grep="error" --oneline -15

# Test failures and debugging
rg "test.*fail|assert.*error|fixture.*error" --type py -n -A 3 | head -10
rg "mock.*error|patch.*error|setup.*error" --type py -n -A 2 | head -10
fd -g "*test*" -x rg "skip|xfail|pytest.mark" {} -n | head -10

# Build and deployment issues
fd -g "Dockerfile" -g "docker-compose*" -x rg "ERROR|error" {} -A 2 | head -10
rg "build.*fail|deploy.*error|ci.*fail" -A 2 | head -10
fd -g ".github" -g ".gitlab-ci*" -x rg "fail|error" {} -A 2 | head -10
```

## Output Format

The generated `troubleshooting.md` will include:

```markdown
<!-- Generated: YYYY-MM-DD HH:MM:SS UTC -->
<!-- Error Tracking: Sentry/Rollbar/etc. -->
<!-- Monitoring: Prometheus/DataDog/etc. -->
<!-- Logging: ELK/Splunk/CloudWatch -->

# Troubleshooting Reference

## Common Issues & Quick Solutions

### Application Startup Issues

#### Database Connection Failures
**Symptoms**: `sqlalchemy.exc.OperationalError: could not connect to server`
**Common Causes**:
- Database not running: `docker-compose up db`
- Wrong connection string: Check `DATABASE_URL` in `.env`
- Network issues: Verify `host` and `port` in connection string

**Debug Steps**:
```bash
# Check database is running
docker ps | grep postgres
# Test connection manually
psql postgresql://user:pass@localhost:5432/dbname
# Check application logs
docker logs app-container
```

#### Port Already in Use
**Symptoms**: `OSError: [Errno 48] Address already in use`
**Resolution**: 
```bash
# Find process using port 8000
lsof -ti:8000
# Kill the process
kill -9 $(lsof -ti:8000)
# Or use different port
export PORT=8001
```

### API Response Issues

#### Authentication Failures (401)
**Error Pattern**: From `src/api/auth.py` L45:
```python
raise HTTPException(
    status_code=401,
    detail="Could not validate credentials",
    headers={"WWW-Authenticate": "Bearer"},
)
```

**Debug Checklist**:
1. **Token expiry**: Check JWT expiration time
2. **Token format**: Verify `Authorization: Bearer <token>` header
3. **Secret key**: Ensure `SECRET_KEY` matches between issuer and validator
4. **Algorithm mismatch**: Verify JWT algorithm consistency

**Debug Commands**:
```bash
# Decode JWT token (without verification)
python -c "import jwt; print(jwt.decode('YOUR_TOKEN', options={'verify_signature': False}))"

# Check token in request
curl -H "Authorization: Bearer YOUR_TOKEN" http://localhost:8000/api/protected
```

#### Validation Errors (422)
**Error Pattern**: From `src/schemas/user.py` validation:
```python
# Common validation error response
{
    "detail": [
        {
            "loc": ["body", "email"],
            "msg": "field required",
            "type": "value_error.missing"
        }
    ]
}
```

**Resolution Steps**:
1. Check request body matches schema requirements
2. Verify required fields are included
3. Validate data types match schema definitions
4. Check custom validators for business logic errors

## Error Patterns & Diagnosis

### Database Error Patterns

#### Connection Pool Exhaustion
**Log Pattern**: `sqlalchemy.exc.TimeoutError: QueuePool limit of size 20 overflow 30 reached`
**Analysis**: From `src/database/session.py` L15:
```python
engine = create_engine(
    DATABASE_URL,
    pool_size=20,        # Base connections
    max_overflow=30,     # Additional connections
    pool_timeout=30,     # Wait time for connection
    pool_recycle=3600    # Recycle connections every hour
)
```

**Solutions**:
1. **Increase pool size**: Adjust `pool_size` and `max_overflow`
2. **Fix connection leaks**: Ensure sessions are properly closed
3. **Add connection monitoring**: Track active connections

#### Deadlock Detection
**Log Pattern**: `deadlock detected`
**Debug Query**: 
```sql
-- PostgreSQL deadlock analysis
SELECT * FROM pg_stat_activity WHERE state = 'active';
SELECT * FROM pg_locks WHERE NOT granted;
```

### Performance Issue Patterns

#### Slow Database Queries
**Detection**: From logs showing query times >1000ms
**Analysis Tools**:
```python
# Enable SQL query logging
import logging
logging.getLogger('sqlalchemy.engine').setLevel(logging.INFO)

# Profile specific queries
from sqlalchemy import event
@event.listens_for(Engine, "before_cursor_execute")
def receive_before_cursor_execute(conn, cursor, statement, parameters, context, executemany):
    context._query_start_time = time.time()

@event.listens_for(Engine, "after_cursor_execute")  
def receive_after_cursor_execute(conn, cursor, statement, parameters, context, executemany):
    total = time.time() - context._query_start_time
    logger.info(f"Query took {total:.3f}s: {statement[:100]}")
```

#### Memory Leaks
**Symptoms**: Gradually increasing memory usage
**Debug Approach**:
```python
# Memory profiling
import tracemalloc
tracemalloc.start()

# At suspected leak point
current, peak = tracemalloc.get_traced_memory()
logger.info(f"Current memory usage: {current / 1024 / 1024:.1f} MB")
logger.info(f"Peak memory usage: {peak / 1024 / 1024:.1f} MB")

# Get top memory consumers
snapshot = tracemalloc.take_snapshot()
top_stats = snapshot.statistics('lineno')
for stat in top_stats[:10]:
    print(stat)
```

## Debugging Tools & Techniques

### Local Development Debugging

#### Python Debugger (pdb)
**Quick Setup**:
```python
# Add breakpoint in code
import pdb; pdb.set_trace()

# Or use Python 3.7+ builtin
breakpoint()

# Useful pdb commands
# n (next line)
# s (step into)
# c (continue)
# l (list code)
# pp variable_name (pretty print)
# q (quit)
```

#### IDE Debugging Configuration
**VS Code**: `.vscode/launch.json`
```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Python: FastAPI",
            "type": "python",
            "request": "launch",
            "program": "${workspaceFolder}/src/main.py",
            "console": "integratedTerminal",
            "env": {
                "DEBUG": "true"
            }
        }
    ]
}
```

### Production Debugging

#### Log Analysis Patterns
**Structured Logging**: From `src/utils/logging.py`:
```python
import structlog

logger = structlog.get_logger()

# Good logging practice
logger.info(
    "User login attempt",
    user_id=user.id,
    email=user.email,
    ip_address=request.client.host,
    success=True
)

# Error logging with context
logger.error(
    "Database query failed",
    query=query_text,
    error=str(e),
    duration_ms=duration,
    user_id=getattr(request.state, 'user_id', None)
)
```

**Log Search Patterns**:
```bash
# Find all errors for specific user
grep "user_id.*12345" logs/app.log | grep ERROR

# Find slow database queries
grep "duration_ms" logs/app.log | awk '$NF > 1000'

# API endpoint error analysis
grep "status_code.*5[0-9][0-9]" logs/access.log | head -20
```

## Monitoring & Alerting

### Health Check Implementation
**Comprehensive Health Check**: From `src/api/health.py` L20-50:
```python
@router.get("/health/detailed")
async def detailed_health_check():
    checks = {}
    overall_status = "healthy"
    
    # Database connectivity
    try:
        await db.execute("SELECT 1")
        checks["database"] = {"status": "healthy", "response_time_ms": 15}
    except Exception as e:
        checks["database"] = {"status": "unhealthy", "error": str(e)}
        overall_status = "unhealthy"
    
    # External API checks
    try:
        response = await httpx.get("https://api.external-service.com/health", timeout=5)
        checks["external_api"] = {
            "status": "healthy" if response.status_code == 200 else "degraded",
            "response_time_ms": response.elapsed.total_seconds() * 1000
        }
    except Exception as e:
        checks["external_api"] = {"status": "unhealthy", "error": str(e)}
        overall_status = "degraded"
    
    return {
        "status": overall_status,
        "timestamp": datetime.utcnow().isoformat(),
        "checks": checks
    }
```

### Error Rate Monitoring
**Alert Thresholds**:
- Error rate >5% over 5 minutes
- Response time >2000ms for 95th percentile
- Health check failures >3 consecutive checks

## Quick Reference Commands

### Database Debugging
```bash
# PostgreSQL connection check
pg_isready -h localhost -p 5432

# Check active connections
psql -c "SELECT count(*) FROM pg_stat_activity;"

# Find long-running queries
psql -c "SELECT query, query_start, state FROM pg_stat_activity WHERE state = 'active' AND query_start < now() - interval '5 minutes';"
```

### Docker Debugging
```bash
# Container health
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Container logs (last 100 lines)
docker logs --tail 100 app-container

# Execute commands in running container
docker exec -it app-container bash

# Check container resource usage
docker stats app-container
```

### Network Debugging
```bash
# Check if service is listening
netstat -tulpn | grep :8000

# Test API connectivity
curl -v http://localhost:8000/health

# Check DNS resolution
nslookup api.external-service.com

# Test database connection
telnet localhost 5432
```

[Additional sections...]
```

## Evaluation Criteria

A successful troubleshooting reference should:

1. **Cover Common Issues**: Address the most frequent problems encountered in development and production
2. **Provide Clear Solutions**: Step-by-step resolution instructions with commands and code examples  
3. **Enable Quick Diagnosis**: Patterns and tools for rapid problem identification
4. **Include Prevention**: Best practices to avoid common issues
5. **Stay Current**: Regular updates based on new issues and resolution patterns

## Maintenance Strategy

**Update Triggers**:
- New error patterns or recurring issues discovered
- Changes to debugging tools or monitoring setup
- Updates to error handling or logging approaches
- New deployment environments or infrastructure changes
- Post-incident learnings and resolution improvements

**Quick Staleness Check**:
```bash
# Check for recent error-related changes or fixes
git log --since="30 days ago" --grep="fix\|bug\|error" --oneline | wc -l

# Review recent error patterns in logs
tail -1000 logs/app.log | grep ERROR | cut -d' ' -f5- | sort | uniq -c | sort -rn | head -10
```