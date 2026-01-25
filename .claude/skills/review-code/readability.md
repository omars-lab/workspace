# Readability Review Guide

## Quick Reference

Evaluate whether code is easy to understand, modify, and maintain. Code is read more than written.

**Key question:** "Would a new team member understand this code quickly?"

## Principles

### 1. Self-Documenting Code
Names clearly express intent. Structure reveals purpose. Comments explain "why", not "what". Code reads like well-written prose.

### 2. Simplicity Over Cleverness
Prefer straightforward solutions. Avoid unnecessary complexity. Make the common case obvious. Don't optimize prematurely.

### 3. Consistency
Follow established patterns. Use consistent naming conventions. Maintain consistent structure. Follow project conventions.

### 4. Single Responsibility
Functions do one thing. Classes have single responsibility. Code organized logically. Dependencies are clear.

### 5. Clarity
Intent is obvious. Logic is easy to follow. Edge cases handled clearly. Error handling is explicit.

## Checklist

### Function Design
- [ ] Functions ≤50 lines (ideal: ≤20 lines)
- [ ] Functions do one thing (describable in one sentence)
- [ ] Parameters ≤5 (ideal: ≤3)
- [ ] No boolean parameters suggesting need for split
- [ ] Return value is obvious
- [ ] Side effects are documented

### Complexity Metrics
- [ ] Cyclomatic complexity ≤10 (ideal: ≤5)
  - Count: if, while, for, case, catch, &&, ||, ?:
- [ ] Nesting depth ≤4 levels (ideal: ≤3)
- [ ] No complex boolean expressions (≤2 operators)

### Naming
- [ ] No single-letter variables (except i, j, k for loops)
- [ ] No abbreviations (tmp, val, str, num, obj, arr, fn, cb)
- [ ] Names ≥3 characters for non-loop variables
- [ ] Booleans are questions (isValid, hasPermission, canEdit)
- [ ] Functions are verbs (getUser, calculateTotal, validateInput)
- [ ] No vague names (doStuff, process, handle, manage, data)
- [ ] Consistent naming convention (camelCase/snake_case)

### Code Structure
- [ ] Related code grouped together
- [ ] Logical flow easy to follow
- [ ] No unnecessary nesting (use early returns)
- [ ] Dependencies explicit and clear
- [ ] Files ≤500 lines (ideal: ≤300)
- [ ] Classes ≤20 methods (ideal: ≤10)

### Comments
- [ ] Comments explain "why", not "what"
- [ ] No obvious comments restating code
- [ ] Complex logic has explanation
- [ ] Edge cases documented
- [ ] Comments are accurate and up-to-date
- [ ] No commented-out code (use version control)

### Error Handling
- [ ] All errors handled explicitly
- [ ] Error messages are clear and helpful
- [ ] Error handling is consistent
- [ ] Failure modes are clear

### Code Quality
- [ ] No magic numbers (use named constants)
- [ ] No code duplication (DRY principle)
- [ ] TODOs have issue numbers or are resolved
- [ ] No FIXMEs in production code

## Detection Patterns

```bash
# Find long functions (lines starting with + in function bodies)
git diff --cached | grep -E "^\+.*(function|def |fn |=>)" || true

# Find deeply nested code
git diff --cached | grep -E "^\+.*\{.*\{.*\{.*\{" || true

# Find complex conditionals
git diff --cached | grep -E "^\+.*&&.*&&|^\+.*\|\|.*\|\|" || true

# Find single-letter variables (excluding loop counters)
git diff --cached | grep -E "^\+.*\b[a-hln-wyz]\s*=" || true

# Find common abbreviations
git diff --cached | grep -i -E "\b(tmp|temp|val|var|str|num|obj|arr|func|fn|cb|ctx)\b" || true

# Find magic numbers
git diff --cached | grep -E "^\+.*[^a-zA-Z][0-9]{2,}[^0-9]" | grep -v -E "(version|date|id|hash|202[0-9])" || true

# Find TODO/FIXME
git diff --cached | grep -i -E "(TODO|FIXME|HACK|XXX)" || true

# Find commented-out code
git diff --cached | grep -E "^\+\s*(//|#)\s*(if|for|while|function|def |return|var |let |const )" || true
```

## Common Issues

| Issue | Impact | Fix |
|-------|--------|-----|
| Single-letter variable | Unclear meaning | Use descriptive name |
| 100+ line function | Hard to understand/test | Extract smaller functions |
| 5+ nesting levels | Cognitive overload | Use early returns, extract methods |
| Magic number `86400` | Unclear meaning | `SECONDS_PER_DAY = 86400` |
| `// increment i` comment | Obvious, adds noise | Delete comment |
| Duplicated code block | Maintenance burden | Extract to shared function |
| `data`, `info`, `obj` names | Vague, unclear purpose | Name by what it represents |

## Examples

### Example 1: Naming
```javascript
// BAD - Vague names, abbreviations
function proc(d) {
  const t = d.filter(x => x.a > 0);
  return t.map(i => i.v * 2);
}

// GOOD - Clear, descriptive names
function filterAndDoublePositiveValues(items) {
  const positiveItems = items.filter(item => item.amount > 0);
  return positiveItems.map(item => item.value * 2);
}
```

### Example 2: Reducing Nesting
```python
# BAD - Deep nesting
def process_order(order):
    if order:
        if order.is_valid:
            if order.has_items:
                if order.payment_confirmed:
                    return ship_order(order)
    return None

# GOOD - Early returns
def process_order(order):
    if not order:
        return None
    if not order.is_valid:
        return None
    if not order.has_items:
        return None
    if not order.payment_confirmed:
        return None
    return ship_order(order)
```

### Example 3: Magic Numbers
```python
# BAD - Magic numbers
if elapsed_time > 86400:
    send_reminder()
if retry_count > 3:
    raise MaxRetriesError()

# GOOD - Named constants
SECONDS_PER_DAY = 86400
MAX_RETRY_ATTEMPTS = 3

if elapsed_time > SECONDS_PER_DAY:
    send_reminder()
if retry_count > MAX_RETRY_ATTEMPTS:
    raise MaxRetriesError()
```
