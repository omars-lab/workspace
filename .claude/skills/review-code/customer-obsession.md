# Customer Obsession Review Guide

## Quick Reference

Evaluate changes from the user's perspective. Consider breaking changes, documentation needs, and downstream impact.

**Key question:** "If I were a user of this code/API/feature, what would I need to know?"

## Principles

### 1. User Impact First
Consider downstream consumers of code and APIs. Think about breaking changes from user perspective. Evaluate if changes improve or degrade user experience.

### 2. Communication is Essential
Breaking changes require migration guides. New features need documentation. Deprecations need timelines and alternatives.

### 3. Backwards Compatibility
Preserve existing behavior when possible. Version appropriately when breaking changes needed. Provide graceful degradation paths.

### 4. Documentation as Product
README is often the first impression. Examples reduce friction. Clear docs reduce support burden.

### 5. Track the Work
Changes that affect users should be tracked. Technical debt should be visible. Follow-up work should be planned.

## Checklist

### Major Functionality Assessment
- [ ] Is this adding significant new capability?
- [ ] Does this change core behavior users depend on?
- [ ] Does this introduce new APIs or endpoints?
- [ ] Does this change data models or schemas?
- [ ] Will users need to learn something new?

**If YES to any:** Documentation update likely required.

### Breaking Changes Detection
- [ ] Does this remove or rename public functions/methods/APIs?
- [ ] Does this change method signatures or parameter types?
- [ ] Does this change return types or response formats?
- [ ] Does this modify configuration format or defaults?
- [ ] Does this change database schema without migration?
- [ ] Does this require consumers to update their code?
- [ ] Does this change error codes or error handling behavior?

**If YES to any:** Requires migration guide + version bump + communication.

### Documentation Requirements
- [ ] README needs update for new features?
- [ ] API documentation needs update?
- [ ] Configuration documentation needs update?
- [ ] CHANGELOG entry added?
- [ ] Migration guide needed for breaking changes?
- [ ] Examples need update or addition?
- [ ] Installation/setup instructions affected?

### Backlog/Planning Impact
- [ ] Does this complete a tracked feature/issue?
- [ ] Does this introduce technical debt needing follow-up?
- [ ] Are there related issues that should be updated?
- [ ] Does this enable or block other planned work?
- [ ] Should new issues be created for follow-up?

### User Communication Assessment
| Change Type | Documentation | Communication |
|------------|---------------|---------------|
| Breaking API change | Migration guide required | Release notes, deprecation notice |
| New feature | Usage docs required | Release notes recommended |
| Behavior change | Update existing docs | Note if user-facing |
| Performance change | Document if significant | Note if degradation |
| Bug fix | Update if workaround existed | Security fixes need advisory |
| Internal refactor | No | No |

## Detection Patterns

```bash
# Find removed/renamed public functions
git diff --cached | grep -E "^-.*export|^-.*public|^-.*def " | head -20 || true

# Find changed function signatures
git diff --cached | grep -E "^[-+].*(function|def |async ).*\(" | head -20 || true

# Find configuration changes
git diff --cached --name-only | grep -i -E "(config|settings|\.env|\.yaml|\.json|\.toml)" || true

# Find schema/migration files
git diff --cached --name-only | grep -i -E "(migration|schema|model)" || true

# Check if README was updated alongside code changes
CODE_CHANGED=$(git diff --cached --name-only | grep -v -E "\.(md|txt)$" | wc -l)
README_UPDATED=$(git diff --cached --name-only | grep -i "readme" | wc -l)
if [ "$CODE_CHANGED" -gt 0 ] && [ "$README_UPDATED" -eq 0 ]; then
  echo "Code changed but README not updated - may need attention"
fi

# Check if CHANGELOG was updated
git diff --cached --name-only | grep -i "changelog" || echo "CHANGELOG not updated"

# Find deprecated markers being added
git diff --cached | grep -i -E "^\+.*(@deprecated|deprecat)" || true

# Find version number changes
git diff --cached | grep -i -E "(version|VERSION)" | grep -E "^\+" || true
```

## Common Issues

| Issue | Impact | Fix |
|-------|--------|-----|
| Breaking change without migration guide | Users can't upgrade | Write migration steps |
| New feature without docs | Users don't know it exists | Add to README/docs |
| Changed defaults without notice | Unexpected behavior | Document in CHANGELOG |
| Removed API without deprecation period | Immediate breakage | Deprecate first, remove later |
| Missing CHANGELOG entry | Users miss important info | Add entry for notable changes |
| Outdated examples | Users get errors | Update examples |

## Examples

### Example 1: Breaking Change Handling
```markdown
## Migration Guide: v2.0 Breaking Changes

### `getUserById` renamed to `getUser`

**Before (v1.x):**
```javascript
const user = await api.getUserById(123);
```

**After (v2.0):**
```javascript
const user = await api.getUser(123);
```

**Migration:** Find and replace `getUserById` with `getUser`. Parameters unchanged.
```

### Example 2: CHANGELOG Entry
```markdown
## [2.1.0] - 2024-01-15

### Added
- New `bulkCreate` method for batch operations (#234)
- Support for custom retry strategies

### Changed
- Default timeout increased from 30s to 60s
- `process()` now returns Promise instead of callback

### Deprecated
- `getUserById()` - use `getUser()` instead (removal in v3.0)

### Fixed
- Race condition in concurrent updates (#456)
```

### Example 3: README Update for New Feature
```markdown
## Features

### Batch Operations (New in v2.1)

Process multiple items efficiently:

```javascript
const results = await client.bulkCreate([
  { name: 'Item 1' },
  { name: 'Item 2' },
]);
```

See [Batch Operations Guide](docs/batch.md) for details.
```

### Example 4: Deprecation Notice
```python
import warnings

def get_user_by_id(user_id):
    """Fetch user by ID.

    .. deprecated:: 2.0
        Use :func:`get_user` instead. Will be removed in version 3.0.
    """
    warnings.warn(
        "get_user_by_id is deprecated, use get_user instead",
        DeprecationWarning,
        stacklevel=2
    )
    return get_user(user_id)
```

### Example 5: Technical Debt Tracking
```python
# TODO(#789): This N+1 query is acceptable for current scale (<1000 users)
# but needs optimization before enterprise launch. Tracked in Q2 roadmap.
# Consider batch loading or caching strategy.
def get_user_permissions(user_id):
    user = get_user(user_id)
    # N+1: Each role triggers separate query
    return [role.permissions for role in user.roles]
```
