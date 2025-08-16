# .claude/create-api-conventions

Generate API design and implementation patterns reference covering endpoint design, error handling, and authentication patterns.

## Usage

```bash
claude < .claude/create-api-conventions
```

## File Management

**Output Location**: `docs/codebase_ref/api_conventions.md`

**Before Starting**: I will check if `docs/codebase_ref/api_conventions.md` already exists and assess whether it needs updating based on:
- Recent changes to API route files
- Updates to schema/model definitions  
- Changes to authentication/authorization code
- New API endpoints or significant modifications to existing ones
- Changes to error handling patterns

**Update Decision Process**:
1. **If file doesn't exist**: Create new comprehensive reference
2. **If file exists**: 
   - Read existing file and analyze timestamp/metadata
   - Check recent commits for API-related changes
   - Compare current endpoint patterns with documented patterns
   - Ask whether you want to:
     - **Update**: Refresh specific sections while preserving structure
     - **Append**: Add new patterns for new endpoints/features
     - **Regenerate**: Create completely fresh file
     - **Skip**: Keep existing file unchanged

## What This Command Creates

An `api_conventions.md` file with:

### Section 1: Endpoint Design Patterns
- **URL Structure** - RESTful patterns, resource naming, nested resources
- **HTTP Methods** - GET, POST, PUT, DELETE usage patterns with examples
- **Status Codes** - Standard response codes used across endpoints
- **Request/Response Format** - JSON structure, pagination, filtering patterns
- **Versioning Strategy** - How API versions are handled

### Section 2: Schema & Validation Patterns
- **Request Models** - Input validation, data transformation patterns
- **Response Models** - Output serialization, field selection patterns
- **Validation Rules** - Business logic validation, field constraints
- **Type Definitions** - Common types, enums, complex data structures

### Section 3: Error Handling
- **Exception Mapping** - How domain exceptions become HTTP responses
- **Error Response Format** - Standard error JSON structure
- **Validation Errors** - Field-level error reporting patterns
- **Logging Patterns** - Error logging and debugging information

### Section 4: Authentication & Authorization
- **Authentication Methods** - Token-based, session-based, OAuth patterns
- **Authorization Patterns** - Role-based, permission-based access control
- **Security Headers** - CORS, security middleware patterns
- **Rate Limiting** - Throttling and abuse prevention patterns

### Section 5: API Documentation
- **OpenAPI/Swagger** - Documentation generation patterns
- **Endpoint Documentation** - Docstring patterns for auto-documentation
- **Example Requests** - Sample requests and responses
- **Testing Patterns** - API testing approaches and examples

## Process

I'll analyze your API codebase to extract patterns by:

1. **File Existence Check** - Assess if update is needed based on recent API changes
2. **Endpoint Discovery** - Find all API routes and analyze patterns
3. **Schema Analysis** - Examine request/response models and validation
4. **Error Pattern Extraction** - Identify error handling approaches
5. **Security Pattern Analysis** - Document authentication and authorization patterns
6. **Documentation Generation** - Create reference with concrete examples and file locations

## Commands Used

```bash
# Check existing file and recent API changes
ls -la docs/codebase_ref/api_conventions.md
git log --oneline -20 --name-only | rg "(api|route|schema|endpoint)"

# Endpoint pattern discovery
rg "@app\.|@router\.|@api\.|@bp\." --type py -A 5 -B 2
rg "\.get\(|\.post\(|\.put\(|\.patch\(|\.delete\(" --type py -n -A 3
rg "status_code=|response_model=" --type py -n -A 2
rg "path.*=|route.*=|endpoint.*=" --type py -n -A 2

# URL and routing patterns
rg '"/\w+|"/{.*}|"/api/' --type py -n -A 1
rg "include_router|add_route|register" --type py -n -A 2
rg "prefix=|tags=|dependencies=" --type py -n

# Schema and validation patterns
rg "BaseModel|Field\(|validator|root_validator" --type py -n -A 3
rg "class.*Schema|class.*Request|class.*Response|class.*Create|class.*Update" --type py -n -A 5
rg "Optional\[|List\[|Dict\[|Union\[" --type py -n | head -20
rg "@field_validator|@model_validator|validates" --type py -n -A 3

# Error handling patterns
rg "HTTPException|raise.*Error|abort\(" --type py -n -A 2
rg "status\.HTTP_|400|401|403|404|422|500" --type py -n -A 1
rg "detail=|message=|errors=" --type py -n -A 2
rg "except.*Exception|try:|except.*Error" --type py -n -A 3

# Authentication and authorization patterns
rg "Depends\(|Security\(|oauth2|jwt|token" --type py -n -A 2
rg "authenticate|authorize|login|logout|verify" --type py -n -A 2
rg "current_user|get_user|check_permission" --type py -n -A 2
rg "Bearer|Authorization|X-API-Key" --type py -n -A 1

# Middleware and security patterns
rg "middleware|CORS|add_middleware" --type py -n -A 3
rg "rate_limit|throttle|limiter" --type py -n -A 2
rg "session|cookie|csrf" --type py -n -A 2

# Documentation patterns
rg "summary=|description=|tags=|response_description=" --type py -n -A 1
rg "\"\"\".*API|\"\"\".*endpoint|\"\"\".*route" --type py -A 5
rg "openapi|swagger|docs_url" --type py -n -A 2

# Response patterns
rg "return.*Response|jsonify|json\.dumps" --type py -n -A 2
rg "pagination|limit|offset|page|per_page" --type py -n -A 2
rg "filter|search|sort|order" --type py -n -A 2
```

## Output Format

The generated `api_conventions.md` will include:

```markdown
<!-- Generated: YYYY-MM-DD HH:MM:SS UTC -->
<!-- Framework: FastAPI/Flask/Django -->
<!-- Total Endpoints: XX -->
<!-- Authentication: JWT/Session/OAuth -->

# API Conventions Reference

## Endpoint Design Patterns

### URL Structure
**Resource Collections** - `GET /api/users/` (list), `POST /api/users/` (create)
**Individual Resources** - `GET /api/users/{id}` (retrieve), `PUT /api/users/{id}` (update)
**Nested Resources** - `GET /api/users/{id}/orders/` from `src/api/routes/users.py` L45
**Action Endpoints** - `POST /api/users/{id}/activate` from `src/api/routes/users.py` L78

### HTTP Method Usage
Pattern from `src/api/routes/users.py`:
```python
@router.get("/", response_model=List[UserResponse])
async def list_users(
    limit: int = Query(10, ge=1, le=100),
    offset: int = Query(0, ge=0),
    current_user: User = Depends(get_current_user)
) -> List[UserResponse]:
    """List users with pagination."""
    # Implementation...
```

## Schema Patterns

### Request Validation
Pattern from `src/schemas/user.py` L15-30:
```python
class UserCreate(BaseModel):
    email: EmailStr = Field(..., description="User email address")
    password: str = Field(..., min_length=8, description="User password")
    
    @field_validator('password')
    def validate_password(cls, v):
        # Password validation logic
        return v
```

### Response Models
Pattern from `src/schemas/user.py` L45-55:
```python
class UserResponse(BaseModel):
    id: int
    email: str
    created_at: datetime
    is_active: bool
    
    class Config:
        from_attributes = True
```

[Additional sections...]
```

## Evaluation Criteria

A successful API conventions reference should:

1. **Reflect Current Patterns**: All examples come from actual endpoint implementations
2. **Guide Consistency**: New endpoints follow established URL, status code, and response patterns
3. **Cover Security**: Authentication and authorization patterns are clearly documented
4. **Handle Errors**: Error response formats and exception handling are standardized
5. **Support Documentation**: API docs generation patterns are established

## Maintenance Strategy

**Update Triggers**:
- New API endpoints added
- Changes to authentication/authorization system
- Updates to request/response schema patterns
- Changes to error handling approach
- New API versioning strategy

**Quick Staleness Check**:
```bash
# Check for recent API-related changes
git log --since="30 days ago" --name-only | rg "(api|route|schema|endpoint)" | wc -l

# Count current endpoints for comparison
rg "@router\.|@app\." --type py -c
```