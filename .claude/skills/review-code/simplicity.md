# Simplicity Review Guide

## Quick Reference

Evaluate whether code takes the simplest approach that works. Question complexity and unnecessary abstractions.

**Key question:** "Is this more complex than it needs to be?"

## Principles

### 1. YAGNI (You Aren't Gonna Need It)
Don't build features you don't need. Don't add abstractions prematurely. Solve today's problem, not tomorrow's.

### 2. KISS (Keep It Simple, Stupid)
Prefer simple solutions. Avoid unnecessary complexity. Make it work, then make it right (if needed).

### 3. Occam's Razor
The simplest solution is usually best. Don't add complexity without clear reason. Question every abstraction.

### 4. Progressive Enhancement
Start simple. Add complexity only when proven needed. Build on solid foundations. Don't optimize prematurely.

### 5. Direct Over Indirect
Prefer direct code over layers of indirection. Abstract only when there's clear benefit. Concrete is often better than abstract.

## Checklist

### Over-Engineering
- [ ] No unnecessary abstractions for current requirements
- [ ] No premature optimization (is there a measured performance problem?)
- [ ] No complex patterns for simple problems
- [ ] No features built "just in case"
- [ ] No over-designed solutions for straightforward needs

### Abstraction Assessment
- [ ] Each abstraction layer adds clear value
- [ ] Abstraction isn't hiding important details
- [ ] No more than 3-4 abstraction layers
- [ ] Would direct code be clearer?
- [ ] Is the abstraction actually needed now?

### Design Patterns
- [ ] Patterns used only where appropriate
- [ ] Patterns not adding unnecessary complexity
- [ ] Simple code preferred over pattern-heavy code
- [ ] No "pattern for pattern's sake"

### Complexity Metrics
- [ ] Cyclomatic complexity ≤10 per function
- [ ] Cognitive complexity ≤15 per function
- [ ] No duplicate code blocks >5 lines
- [ ] Inheritance depth ≤3 levels
- [ ] Parameter count ≤5 per function

### Dependencies
- [ ] Each dependency is necessary
- [ ] Standard library used where possible
- [ ] No heavy frameworks for lightweight needs
- [ ] Dependencies worth their added complexity

### Code Size
- [ ] Functions ≤50 lines
- [ ] Classes ≤500 lines
- [ ] Files ≤1000 lines
- [ ] No god objects (classes doing too much)

### Operational Simplicity
- [ ] If Makefile exists, new functionality has corresponding targets
- [ ] If package.json scripts exist, new commands are added
- [ ] Build/test/run commands documented or obvious
- [ ] New services/tools can be run locally (not just in CI/cloud)
- [ ] Local development setup is straightforward
- [ ] No hidden dependencies on remote services for basic functionality
- [ ] Environment setup documented if changed

### Local Execution
- [ ] Can run/test changes locally without special infrastructure
- [ ] Local dev instructions exist and are current
- [ ] Mock/stub options for external dependencies
- [ ] Docker/container setup works locally if used
- [ ] Scripts work on developer machines (not just CI)

## Detection Patterns

```bash
# Find design patterns (may indicate over-engineering)
git diff --cached | grep -i -E "(Factory|Builder|Strategy|Observer|Singleton|Adapter|Decorator|Facade|Proxy)" || true

# Find multiple inheritance/interfaces
git diff --cached | grep -E "^\+.*(implements.*,|extends.*,)" || true

# Find complex generics
git diff --cached | grep -E "^\+.*<.*<.*<" || true

# Find dependency injection markers
git diff --cached | grep -i -E "(@Inject|@Autowired|@Component|@Service)" || true

# Find wrapper/adapter classes
git diff --cached | grep -i -E "(Wrapper|Adapter|Facade|Proxy|Decorator)>" || true

# Find abstract classes/interfaces
git diff --cached | grep -E "^\+.*(interface |abstract class )" || true

# Find potential code duplication
git diff --cached | grep -E "^\+" | sort | uniq -d | head -20

# Check if Makefile exists and might need updates
if [ -f Makefile ]; then
  echo "Makefile exists - verify new functionality has targets"
  git diff --cached --name-only | grep -v "Makefile" | head -5
fi

# Check if package.json scripts might need updates
if [ -f package.json ]; then
  echo "package.json exists - verify scripts section if adding new commands"
fi

# Find new executable files without Makefile targets
git diff --cached --name-only | grep -E "\.(sh|py|js)$" || true

# Check for hardcoded remote URLs (may need local alternative)
git diff --cached | grep -i -E "(https?://|localhost:[0-9]+)" | grep -v -E "(example\.com|test)" || true

# Find Docker/container changes
git diff --cached --name-only | grep -i -E "(docker|compose|container)" || true
```

## Common Issues

| Issue | Sign | Fix |
|-------|------|-----|
| Premature abstraction | Interface with one implementation | Use concrete class until need second |
| Over-engineered factory | Simple object creation wrapped in factory | Direct instantiation |
| Unnecessary wrapper | Class that just delegates to another | Remove wrapper, use directly |
| Future-proofing | Code for hypothetical requirements | Delete, build when needed |
| Complex algorithm for simple problem | Sorting 10 items with custom comparator | Simple approach often sufficient |
| Too many layers | Request → Controller → Service → Repository → DAO | Flatten if layers don't add value |
| Missing Makefile target | New script with no `make` entry | Add target for discoverability |
| Only runs in CI | Code requires CI environment to test | Add local execution path |
| Hidden remote dependency | Fails without internet/VPN | Mock/stub for local dev |

## Examples

### Example 1: Premature Abstraction
```python
# BAD - Over-engineered for one use case
class UserRepositoryInterface(ABC):
    @abstractmethod
    def get_user(self, id): pass

class UserRepository(UserRepositoryInterface):
    def get_user(self, id):
        return db.query(User).filter_by(id=id).first()

class UserService:
    def __init__(self, repo: UserRepositoryInterface):
        self.repo = repo

# GOOD - Simple and direct
class UserService:
    def get_user(self, id):
        return db.query(User).filter_by(id=id).first()
```

### Example 2: Unnecessary Pattern
```javascript
// BAD - Factory for simple object
class ConfigFactory {
  static create(env) {
    return new Config(env);
  }
}
const config = ConfigFactory.create('production');

// GOOD - Direct creation
const config = new Config('production');
// Or even simpler:
const config = { env: 'production', /* ... */ };
```

### Example 3: YAGNI Violation
```python
# BAD - Building for hypothetical future
class DataProcessor:
    def __init__(self, strategy=None, cache=None, validator=None,
                 transformer=None, logger=None, metrics=None):
        # Complex initialization for features not yet needed
        pass

# GOOD - Build what you need now
class DataProcessor:
    def process(self, data):
        validated = self._validate(data)
        return self._transform(validated)
```

### Example 4: Too Many Layers
```python
# BAD - Unnecessary indirection
class UserController:
    def get(self, id):
        return self.service.get_user(id)

class UserService:
    def get_user(self, id):
        return self.repository.find(id)

class UserRepository:
    def find(self, id):
        return self.dao.get(id)

class UserDAO:
    def get(self, id):
        return db.query(User).get(id)

# GOOD - Flatten when layers don't add value
class UserController:
    def get(self, id):
        return db.query(User).get(id)
```

### Example 5: Operational Simplicity
```makefile
# BAD - New script added but not accessible via Makefile
# scripts/deploy.sh exists but developers don't know about it

# GOOD - Makefile makes functionality discoverable
.PHONY: deploy test lint build

deploy:        ## Deploy to staging environment
	./scripts/deploy.sh staging

deploy-prod:   ## Deploy to production (requires approval)
	./scripts/deploy.sh production

test:          ## Run all tests locally
	pytest tests/

test-quick:    ## Run fast unit tests only
	pytest tests/unit/ -x

lint:          ## Run linters
	ruff check .

# Show help by default
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "%-15s %s\n", $$1, $$2}'
```

### Example 6: Local Execution
```python
# BAD - Only works with real external service
class PaymentProcessor:
    def __init__(self):
        self.client = StripeClient(os.environ['STRIPE_KEY'])  # Fails locally without key

    def charge(self, amount):
        return self.client.charge(amount)  # Requires internet, real API

# GOOD - Supports local development
class PaymentProcessor:
    def __init__(self, client=None):
        if client:
            self.client = client
        elif os.environ.get('USE_MOCK_PAYMENTS'):
            self.client = MockPaymentClient()
        else:
            self.client = StripeClient(os.environ['STRIPE_KEY'])

    def charge(self, amount):
        return self.client.charge(amount)

# Local dev: USE_MOCK_PAYMENTS=1 python app.py
# Tests: PaymentProcessor(client=MockPaymentClient())
```
