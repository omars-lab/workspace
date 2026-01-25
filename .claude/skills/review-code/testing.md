# Testing Review Guide

## Quick Reference

Evaluate test coverage, quality, and strategy. Tests should catch real bugs and enable safe refactoring.

**Key question:** "Would these tests catch the bugs that matter?"

## Principles

### 1. Test What Matters
Test critical paths and business logic. Test edge cases and error conditions. Test behavior, not implementation details.

### 2. Tests Should Be Reliable
Tests are deterministic (same result every run). Tests don't depend on external state (network, DB, filesystem, time). Tests are isolated and can run in any order.

### 3. Tests Should Be Maintainable
Tests are easy to understand and modify. Test code quality matters. Follow DRY, but not at expense of clarity.

### 4. Tests Enable Change
Tests catch real bugs. Tests document expected behavior. Tests give confidence to refactor.

### 5. Right Level of Testing
Unit tests for logic. Integration tests for boundaries. E2E tests for critical user flows. More unit tests, fewer E2E tests (test pyramid).

## Checklist

### Coverage Requirements
- [ ] All public functions/methods have tests
- [ ] All API endpoints have tests
- [ ] All user-facing features have tests
- [ ] Critical business logic has tests
- [ ] Error handling paths have tests

### Edge Cases
- [ ] Boundary conditions tested (0, -1, max, min, empty)
- [ ] Null/undefined/None values tested
- [ ] Empty collections/strings tested
- [ ] Invalid input tested
- [ ] Maximum/minimum values tested

### Test Quality
- [ ] Tests follow AAA pattern (Arrange, Act, Assert)
- [ ] Test names describe what is being tested
- [ ] Each test tests one thing
- [ ] Tests are independent (no shared state)
- [ ] Tests are deterministic (no flaky tests)
- [ ] Assertions are specific (not just "no error")

### Test Structure
- [ ] Tests organized logically (mirror source structure)
- [ ] Test setup is clear and minimal
- [ ] Test data is clear and purposeful
- [ ] Mocks/stubs used appropriately
- [ ] No excessive mocking (tests implementation details)

### Test Maintainability
- [ ] No duplicated test code (use helpers/fixtures)
- [ ] No hard-coded test data without meaning
- [ ] Tests not tightly coupled to implementation
- [ ] Test utilities are reusable

### Missing Tests
- [ ] New features have tests
- [ ] Bug fixes have regression tests
- [ ] Refactored code maintains test coverage

## Detection Patterns

```bash
# Find test files in staged changes
git diff --cached --name-only | grep -i -E "(test|spec)" || echo "No test files"

# Check for new source files without tests
git diff --cached --name-only --diff-filter=A | grep -v -i -E "(test|spec)" || true

# Find test assertions
git diff --cached | grep -i -E "(assert|expect|should|verify)" || true

# Find test definitions
git diff --cached | grep -i -E "(it\(|test\(|describe\(|def test_)" || true

# Find mocking
git diff --cached | grep -i -E "(mock|stub|spy|fake|patch)" || true

# Find potential flaky patterns (sleep, setTimeout in tests)
git diff --cached | grep -i -E "(sleep|setTimeout|delay)" | grep -i -E "(test|spec)" || true

# Find time-dependent tests
git diff --cached | grep -i -E "(Date\.now|new Date|time\.time)" | grep -i -E "(test|spec)" || true
```

## Common Issues

| Issue | Problem | Fix |
|-------|---------|-----|
| No tests for new code | Bugs ship undetected | Add tests before/with code |
| Tests only happy path | Edge cases cause bugs | Test error cases, boundaries |
| Flaky tests | False failures, ignored tests | Remove time/order dependencies |
| Testing implementation | Tests break on refactor | Test behavior/outcomes |
| Excessive mocking | Tests don't catch real bugs | Mock boundaries, not internals |
| Unclear test names | Hard to understand failures | `test_returns_empty_list_when_no_items_match` |
| Shared test state | Tests affect each other | Isolate tests, fresh setup each |

## Examples

### Example 1: Test Naming
```python
# BAD - Vague name
def test_user():
    user = create_user("test@example.com")
    assert user.email == "test@example.com"

# GOOD - Descriptive name
def test_create_user_sets_email_from_input():
    user = create_user("test@example.com")
    assert user.email == "test@example.com"
```

### Example 2: AAA Pattern
```javascript
// BAD - Mixed arrange/act/assert
test('processes order', () => {
  const order = new Order();
  order.addItem('widget');
  expect(order.items.length).toBe(1);
  order.addItem('gadget');
  expect(order.items.length).toBe(2);
  order.process();
  expect(order.status).toBe('processed');
});

// GOOD - Clear AAA structure
test('process sets order status to processed', () => {
  // Arrange
  const order = new Order();
  order.addItem('widget');

  // Act
  order.process();

  // Assert
  expect(order.status).toBe('processed');
});
```

### Example 3: Edge Cases
```python
# BAD - Only happy path
def test_divide():
    assert divide(10, 2) == 5

# GOOD - Including edge cases
def test_divide_returns_quotient():
    assert divide(10, 2) == 5

def test_divide_by_zero_raises_error():
    with pytest.raises(ZeroDivisionError):
        divide(10, 0)

def test_divide_with_negative_numbers():
    assert divide(-10, 2) == -5
    assert divide(10, -2) == -5

def test_divide_returns_float_for_non_integer_result():
    assert divide(5, 2) == 2.5
```

### Example 4: Avoiding Implementation Testing
```javascript
// BAD - Testing implementation (internal method calls)
test('saves user', () => {
  const db = mock(Database);
  const service = new UserService(db);

  service.createUser('test@example.com');

  expect(db.connect).toHaveBeenCalled();
  expect(db.beginTransaction).toHaveBeenCalled();
  expect(db.insert).toHaveBeenCalledWith('users', {...});
  expect(db.commit).toHaveBeenCalled();
});

// GOOD - Testing behavior/outcome
test('createUser persists user and returns with id', async () => {
  const service = new UserService(testDb);

  const user = await service.createUser('test@example.com');

  expect(user.id).toBeDefined();
  expect(await testDb.findUser(user.id)).toMatchObject({
    email: 'test@example.com'
  });
});
```
