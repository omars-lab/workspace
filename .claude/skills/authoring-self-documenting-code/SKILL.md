---
name: authoring-self-documenting-code
description: Guidance on authoring code that is easy to read, maintable, well documented, well named, etc.
---

# Self-Documenting Code Skill

## Purpose

This skill ensures that all code written is properly organized, documented, and self-explanatory. The goal is to create code that communicates its intent clearly through structure, naming, and strategic comments, making it easier to understand, maintain, and modify.

## Core Principles

### 1. Intent-Focused Documentation
- **Comments explain "why" and "what", not "how"**
  - Code should be clear enough that "how" is obvious
  - Comments should capture the intent, context, and reasoning behind decisions
  - Document non-obvious business logic, edge cases, and design decisions

### 2. Intent Change Tracking
- **When intent changes, make it explicit**
  - When refactoring or modifying code, clearly document:
    - What the previous intent was (if relevant)
    - That the previous intent has been completed/phased out
    - What the new intent is
  - Use comments to mark transitions: `# Previous: [old intent] → New: [new intent]`
  - Update related documentation when intent evolves

### 3. Code Organization
- **Group shared intent into functions/modules**
  - Extract repeated logic into reusable functions
  - Group related functionality into cohesive modules/classes
  - Use clear, descriptive names that convey purpose
  - Keep functions focused on a single responsibility

### 4. Structure Over Comments
- **Prefer clear structure over excessive comments**
  - Well-named variables, functions, and classes reduce need for comments
  - Logical code organization makes flow obvious
  - Use type hints, docstrings, and clear naming conventions

## Guidelines

### Function/Class Documentation
- **Every public function/class should have a docstring** explaining:
  - Purpose and intent
  - Parameters and return values
  - Any side effects or important behaviors
  - Usage examples for complex functions

### Inline Comments
- **Use inline comments for:**
  - Complex algorithms or non-obvious logic
  - Business rules and domain-specific decisions
  - Workarounds or temporary solutions (with TODO/FIXME)
  - Performance optimizations that might look odd
  - References to external documentation or issues

### Code Organization
- **Organize code by intent, not by type:**
  - Group related functions together
  - Place helper functions near their usage
  - Use clear module boundaries
  - Separate concerns into distinct modules/classes

### Naming Conventions
- **Names should be self-documenting:**
  - Function names: verb phrases (`calculate_total`, `validate_input`)
  - Variable names: noun phrases (`user_count`, `is_valid`)
  - Class names: noun phrases (`FileProcessor`, `DataValidator`)
  - Boolean names: questions (`is_active`, `has_permission`)

## Examples

### Good: Intent-Focused Comments
```python
# Calculate discount based on membership tier and purchase history
# Members with 10+ purchases get an additional 5% loyalty discount
def calculate_discount(member_tier: str, purchase_count: int) -> float:
    base_discount = TIER_DISCOUNTS[member_tier]
    
    # Apply loyalty bonus for frequent customers
    # This encourages repeat business and rewards engagement
    if purchase_count >= 10:
        base_discount += 0.05
    
    return base_discount
```

### Good: Intent Change Documentation
```python
# Previous: Simple file move operation
# New: Move with conflict resolution and backup
# Changed to handle concurrent access scenarios (Issue #123)
def move_file_with_backup(source: str, dest: str) -> bool:
    # ... implementation
```

### Good: Shared Intent Extraction
```python
# Before: Repeated logic
if user.age >= 18 and user.verified and user.subscription_active:
    process_payment(user)
if admin.age >= 18 and admin.verified and admin.subscription_active:
    process_payment(admin)

# After: Extracted shared intent
def can_process_payment(account: Account) -> bool:
    """Check if account meets all requirements for payment processing."""
    return (account.age >= 18 and 
            account.verified and 
            account.subscription_active)

if can_process_payment(user):
    process_payment(user)
if can_process_payment(admin):
    process_payment(admin)
```

## Checklist

When writing or reviewing code, ensure:

- [ ] **Intent is clear** - Code purpose is obvious from structure and naming
- [ ] **Comments explain "why"** - Not just restating what code does
- [ ] **Shared logic is extracted** - Repeated patterns are in functions/modules
- [ ] **Intent changes are documented** - Transitions from old to new approach are marked
- [ ] **Functions have docstrings** - Public APIs are documented
- [ ] **Complex logic is explained** - Non-obvious algorithms have inline comments
- [ ] **Code is organized by purpose** - Related functionality is grouped together
- [ ] **Names are descriptive** - Variables/functions/classes convey their purpose

## Anti-Patterns to Avoid

❌ **Commenting the obvious:**
```python
# Increment counter by 1
counter += 1
```

❌ **No documentation for complex logic:**
```python
def process(data):
    result = []
    for i in range(len(data)):
        if i % 2 == 0 and data[i] > threshold:
            result.append(transform(data[i]))
    return result
```

❌ **Unclear intent:**
```python
def do_stuff(x, y):
    # What does this do? Why?
    return x * y + 42
```

## Application

Apply this skill when:
- Writing new code
- Refactoring existing code
- Reviewing code changes
- Adding features or fixing bugs
- Any time code clarity or organization can be improved

Remember: **Code is read far more often than it's written.** Invest in clarity and organization to save time and reduce errors in the future.
