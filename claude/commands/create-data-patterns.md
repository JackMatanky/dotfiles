# .claude/create-data-patterns

Generate database and data handling patterns reference covering model definitions, migrations, query patterns, and caching strategies.

## Usage

```bash
claude < .claude/create-data-patterns
```

## File Management

**Output Location**: `docs/codebase_ref/data_patterns.md`

**Before Starting**: I will check if `docs/codebase_ref/data_patterns.md` already exists and assess whether it needs updating based on:
- Recent database migrations
- Changes to model definitions
- Updates to database configuration
- New repository or service patterns
- Changes to caching or data validation approaches

**Update Decision Process**:
1. **If file doesn't exist**: Create new comprehensive reference
2. **If file exists**: 
   - Read existing file and analyze timestamp/metadata
   - Check recent commits for data-related changes
   - Compare current model patterns with documented patterns
   - Ask whether you want to:
     - **Update**: Refresh specific sections while preserving structure
     - **Append**: Add new patterns for new models/features
     - **Regenerate**: Create completely fresh file
     - **Skip**: Keep existing file unchanged

## What This Command Creates

A `data_patterns.md` file with:

### Section 1: Model Definitions
- **Entity Patterns** - Base classes, inheritance, composition patterns
- **Field Definitions** - Common field types, constraints, validation
- **Relationships** - Foreign keys, one-to-many, many-to-many patterns
- **Model Methods** - Common instance methods, class methods, properties
- **Validation Rules** - Field-level and model-level validation patterns

### Section 2: Database Configuration
- **Connection Setup** - Database URL, connection pooling, session management
- **Environment Configuration** - Development, testing, production database settings
- **Migration Configuration** - Alembic setup, migration file organization
- **Index Strategies** - Performance optimization through indexing

### Section 3: Migration Patterns
- **Schema Changes** - Adding/removing columns, tables, constraints
- **Data Migrations** - Transforming existing data during schema changes
- **Rollback Strategies** - Safe migration rollbacks and error handling
- **Testing Migrations** - Validation and testing approaches for migrations

### Section 4: Query Patterns
- **Basic Queries** - CRUD operations, filtering, sorting patterns
- **Complex Queries** - Joins, subqueries, aggregations with examples
- **Performance Optimization** - N+1 prevention, eager loading, query analysis
- **Repository Patterns** - Data access layer abstraction and testing

### Section 5: Caching & Performance
- **Caching Strategies** - What to cache, cache invalidation patterns
- **Query Optimization** - Index usage, query planning, performance monitoring
- **Connection Management** - Pool sizing, connection lifecycle, error handling
- **Data Serialization** - JSON fields, custom serializers, data transformation

## Process

I'll analyze your data layer to extract patterns by:

1. **File Existence Check** - Assess if update is needed based on recent data changes
2. **Model Discovery** - Find all data models and analyze patterns
3. **Migration Analysis** - Examine migration files for schema change patterns
4. **Query Pattern Extraction** - Identify common query and repository patterns
5. **Performance Pattern Analysis** - Document caching and optimization approaches
6. **Documentation Generation** - Create reference with concrete examples and file locations

## Commands Used

```bash
# Check existing file and recent data changes
ls -la docs/codebase_ref/data_patterns.md
git log --oneline -20 --name-only | rg "(model|migration|database|schema)"

# Model pattern discovery
rg "class.*\(.*Model\)|class.*\(.*Base\)" --type py -A 5
rg "db\.Model|Base|DeclarativeBase" --type py -n -A 3
rg "__tablename__|table_name" --type py -n -A 2
rg "Column\(|Field\(" --type py -n -A 2

# Relationship patterns
rg "relationship\(|ForeignKey|foreign_key" --type py -n -A 2
rg "backref|back_populates|lazy=" --type py -n -A 1
rg "one-to-many|many-to-one|many-to-many" --type py -n -A 2
rg "joinedload|selectinload|subqueryload" --type py -n -A 2

# Validation patterns
rg "validates|hybrid_property|@property" --type py -n -A 3
rg "@field_validator|@model_validator|@validates" --type py -n -A 3
rg "CheckConstraint|UniqueConstraint|Index" --type py -n -A 2

# Database configuration
fd -g "*config*" -g "*settings*" -x rg "database|db" {} -n -A 2
rg "DATABASE_URL|SQLALCHEMY_|engine|sessionmaker" --type py -n -A 2
rg "create_engine|Session|scoped_session" --type py -n -A 3

# Migration patterns
fd -g "*migration*" -g "*alembic*" -x head -10 {}
fd -g "alembic.ini" -g "env.py" -x head -15 {}
rg "upgrade\(\)|downgrade\(\)" --type py -n -A 5
rg "op\.|batch_op\." --type py -n -A 2

# Query patterns
rg "select\(|query\(|filter\(|filter_by\(" --type py -n -A 2
rg "join\(|outerjoin\(|order_by\(" --type py -n -A 2
rg "group_by\(|having\(|limit\(|offset\(" --type py -n -A 2
rg "first\(\)|all\(\)|one\(\)|scalar\(" --type py -n -A 1

# Repository patterns
rg "class.*Repository|class.*DAO|class.*Service" --type py -n -A 5
rg "def get_|def find_|def create_|def update_|def delete_" --type py -n -A 3
rg "session\.|db\.|commit\(\)|rollback\(\)" --type py -n -A 2

# Caching patterns
rg "cache|Cache|redis|memcached|@lru_cache|@cached" --type py -n -A 2
rg "expire|ttl|invalidate|clear_cache" --type py -n -A 2
rg "serialize|deserialize|json\.dumps|pickle" --type py -n -A 2

# Performance and optimization
rg "index|Index|primary_key|unique=" --type py -n -A 1
rg "lazy=|eager|joinedload|selectinload" --type py -n -A 2
rg "pool_|connection_|timeout=" --type py -n -A 2
```

## Output Format

The generated `data_patterns.md` will include:

```markdown
<!-- Generated: YYYY-MM-DD HH:MM:SS UTC -->
<!-- ORM: SQLAlchemy/Django/etc. -->
<!-- Database: PostgreSQL/MySQL/SQLite -->
<!-- Migration Tool: Alembic/Django/etc. -->

# Data Patterns Reference

## Model Definition Patterns

### Base Model Pattern
From `src/models/base.py` L10-25:
```python
class BaseModel(Base):
    __abstract__ = True
    
    id = Column(Integer, primary_key=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    def to_dict(self):
        return {c.name: getattr(self, c.name) for c in self.__table__.columns}
```

### Entity Model Pattern
From `src/models/user.py` L15-35:
```python
class User(BaseModel):
    __tablename__ = 'users'
    
    email = Column(String(255), unique=True, nullable=False, index=True)
    password_hash = Column(String(255), nullable=False)
    is_active = Column(Boolean, default=True)
    
    # Relationships
    orders = relationship("Order", back_populates="user", lazy="dynamic")
    
    @validates('email')
    def validate_email(self, key, email):
        if '@' not in email:
            raise ValueError('Invalid email address')
        return email.lower()
```

## Relationship Patterns

### One-to-Many Pattern
From `src/models/user.py` and `src/models/order.py`:
```python
# User model (one side)
orders = relationship("Order", back_populates="user", cascade="all, delete-orphan")

# Order model (many side)
user_id = Column(Integer, ForeignKey('users.id'), nullable=False)
user = relationship("User", back_populates="orders")
```

### Many-to-Many Pattern
From `src/models/product.py` L25-35:
```python
# Association table
product_categories = Table('product_categories', Base.metadata,
    Column('product_id', Integer, ForeignKey('products.id')),
    Column('category_id', Integer, ForeignKey('categories.id'))
)

# Product model
categories = relationship("Category", secondary=product_categories, back_populates="products")
```

## Query Patterns

### Repository Pattern
From `src/repositories/user_repository.py` L15-40:
```python
class UserRepository:
    def __init__(self, session: Session):
        self.session = session
    
    def get_by_id(self, user_id: int) -> Optional[User]:
        return self.session.query(User).filter(User.id == user_id).first()
    
    def get_by_email(self, email: str) -> Optional[User]:
        return self.session.query(User).filter(User.email == email).first()
    
    def get_active_users(self, limit: int = 100, offset: int = 0) -> List[User]:
        return (self.session.query(User)
                .filter(User.is_active == True)
                .limit(limit)
                .offset(offset)
                .all())
```

### Performance-Optimized Queries
From `src/services/order_service.py` L25-35:
```python
# Eager loading to prevent N+1 queries
def get_orders_with_details(self, user_id: int) -> List[Order]:
    return (self.session.query(Order)
            .options(
                joinedload(Order.user),
                selectinload(Order.items).joinedload(OrderItem.product)
            )
            .filter(Order.user_id == user_id)
            .all())
```

[Additional sections...]
```

## Evaluation Criteria

A successful data patterns reference should:

1. **Reflect Current Architecture**: All examples come from actual model implementations
2. **Guide Performance**: Query optimization and caching patterns prevent common issues
3. **Ensure Consistency**: Model definition and relationship patterns are standardized
4. **Support Migrations**: Safe schema change patterns are documented
5. **Enable Testing**: Repository patterns facilitate unit testing and mocking

## Maintenance Strategy

**Update Triggers**:
- New model definitions or relationship changes
- Database schema migrations
- Changes to caching or performance optimization strategies
- Updates to database configuration or connection handling
- New query patterns or repository implementations

**Quick Staleness Check**:
```bash
# Check for recent data-related changes
git log --since="30 days ago" --name-only | rg "(model|migration|database)" | wc -l

# Count current models for comparison
rg "class.*\(.*Model\)" --type py -c
```