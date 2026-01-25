# Documentation Review Guide

## Quick Reference

Evaluate whether code is self-documenting and appropriately documented. Code should communicate intent clearly.

**Key question:** "Can someone understand this code's purpose without asking the author?"

## Principles

### 1. Self-Documenting Code First
Names clearly express intent. Structure reveals purpose. Code should be understandable without comments.

### 2. Comments Explain Why, Not What
Code shows "what" and "how". Comments explain "why" - the reasoning, context, and non-obvious decisions.

### 3. Document at the Right Level
Public APIs need documentation. Complex logic needs explanation. Obvious code needs no comments.

### 4. Keep Documentation Current
Outdated docs are worse than no docs. Update comments when code changes. Delete obsolete documentation.

### 5. Intent Over Implementation
Document the purpose, not the mechanism. Explain business rules, not code mechanics.

## Checklist

### Self-Documenting Code
- [ ] Function names describe what they do (verbs)
- [ ] Variable names describe what they contain
- [ ] Class names describe what they represent (nouns)
- [ ] Boolean names are questions (isValid, hasPermission)
- [ ] No abbreviations or jargon
- [ ] Code structure reveals intent

### Public API Documentation
- [ ] All public functions have docstrings/JSDoc
- [ ] Parameters documented with types and meaning
- [ ] Return values documented
- [ ] Exceptions/errors documented
- [ ] Side effects documented
- [ ] Examples provided for complex APIs

### Inline Comments
- [ ] Complex algorithms have explanation
- [ ] Non-obvious business logic documented
- [ ] Edge cases explained
- [ ] Workarounds/hacks have context (why and when to remove)
- [ ] No obvious comments ("increment counter")
- [ ] Comments match the code (not stale)

### Project Documentation
- [ ] README explains project purpose and setup
- [ ] CHANGELOG tracks notable changes
- [ ] API documentation is complete
- [ ] Configuration options documented
- [ ] Examples provided for common use cases

### Intent Tracking
- [ ] Intent changes are documented
- [ ] Deprecated code is marked with alternatives
- [ ] TODOs have context and/or issue numbers
- [ ] FIXMEs explain the problem and impact

## Detection Patterns

```bash
# Find public functions (may need docs)
git diff --cached | grep -E "^\+.*(export|public|def ).*(function|class|interface)" || true

# Find functions without preceding comments
git diff --cached | grep -B1 -E "^\+.*(function|def |class )" | grep -v "^\+.*(/\*\*|///|#|\"\"\")" || true

# Find TODO/FIXME without issue numbers
git diff --cached | grep -i -E "(TODO|FIXME)" | grep -v -E "(TODO.*#[0-9]|FIXME.*#[0-9]|TODO.*issue|FIXME.*ticket)" || true

# Find magic numbers needing explanation
git diff --cached | grep -E "^\+.*[^a-zA-Z_][0-9]{2,}[^0-9]" | grep -v -E "(version|date|id|port|status)" || true

# Find vague variable names
git diff --cached | grep -E "^\+.*(data|info|temp|tmp|obj|val|result)\s*=" || true

# Find obvious comments
git diff --cached | grep -E "^\+.*//\s*(increment|set|get|return|loop|iterate)" || true
```

## Common Issues

| Issue | Problem | Fix |
|-------|---------|-----|
| Missing API docs | Users can't use code correctly | Add docstring with params/return |
| `// increment i` | Obvious, adds noise | Delete the comment |
| Stale comment | Misleads readers | Update or delete |
| `data`, `result`, `tmp` | Unclear purpose | Name by what it represents |
| TODO without context | Never gets fixed | Add issue number or remove |
| Missing "why" | Can't understand decisions | Explain reasoning |
| Abbreviations | Unclear to newcomers | Spell it out |

## Examples

### Example 1: Self-Documenting Names
```python
# BAD - Needs comments to understand
def proc(d, f):
    # Filter data by flag and return count
    return len([x for x in d if x.f == f])

# GOOD - Names explain everything
def count_items_with_status(items, target_status):
    return len([item for item in items if item.status == target_status])
```

### Example 2: Explaining Why
```javascript
// BAD - Comment says what (obvious from code)
// Check if user is admin
if (user.role === 'admin') {
  // Skip validation
  return true;
}

// GOOD - Comment explains why
// Admins bypass validation because they manage the rules themselves
// and need to test edge cases during configuration
if (user.role === 'admin') {
  return true;
}
```

### Example 3: Docstring
```python
# BAD - No documentation
def calculate_shipping(weight, destination, express):
    ...

# GOOD - Clear documentation
def calculate_shipping(weight: float, destination: str, express: bool = False) -> Decimal:
    """Calculate shipping cost based on package weight and destination.

    Args:
        weight: Package weight in kilograms
        destination: Two-letter country code (ISO 3166-1 alpha-2)
        express: If True, use express shipping rates (2-3 day delivery)

    Returns:
        Shipping cost in USD

    Raises:
        ValueError: If destination is not a supported country
        ValueError: If weight exceeds maximum (30kg standard, 10kg express)

    Example:
        >>> calculate_shipping(2.5, 'US', express=True)
        Decimal('24.99')
    """
```

### Example 4: Intent Change Documentation
```python
# When intent changes, document the transition:

# DEPRECATED: This validation was required for legacy API v1.
# Remove after 2024-06-01 when v1 is sunset (see issue #1234).
# New validation is in validate_order_v2().
def validate_order_legacy(order):
    ...

# Current validation for API v2+
def validate_order(order):
    ...
```

### Example 5: TODO with Context
```javascript
// BAD - Vague TODO, will never be fixed
// TODO: fix this later

// GOOD - Actionable TODO with context
// TODO(#1234): Replace with bulk API once available (Q2 2024).
// Current N+1 query is acceptable for <100 items but will need
// optimization for enterprise customers with larger datasets.
```
