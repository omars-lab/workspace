---
name: review-code
description: Comprehensive code review with parallel agents for security, readability, simplicity, testing, documentation, and customer impact.
---

# Code Review Skill

## Purpose

Perform comprehensive code reviews on staged git changes using targeted review agents. Reviews cover security, readability, simplicity, testing, documentation, and customer impact.

## When to Use

- Before committing code changes
- When asked about code quality, security, or best practices
- For comprehensive pre-merge reviews

## Conditional Execution

**Not all checks run on all commits.** Determine scope before running agents.

### Quick Assessment

```bash
# 1. Check change magnitude
git diff --cached --shortstat

# 2. Detect file types
git diff --cached --name-only | sed 's/.*\.//' | sort | uniq -c

# 3. Check for security-sensitive files
git diff --cached --name-only | grep -i -E "(auth|login|password|secret|token|crypto|permission)" && echo "SECURITY_SENSITIVE"

# 4. Check if docs-only
git diff --cached --name-only | grep -v -E "\.(md|txt|rst)$" | wc -l | grep -q "^0$" && echo "DOCS_ONLY"

# 5. Check if tests-only
git diff --cached --name-only | grep -v -i -E "(test|spec)" | wc -l | grep -q "^0$" && echo "TESTS_ONLY"
```

### Category Selection Matrix

| Change Type | Security | Readability | Simplicity | Testing | Docs | Customer |
|-------------|----------|-------------|------------|---------|------|----------|
| New feature (>50 lines) | YES | YES | YES | YES | YES | YES |
| Bug fix (<20 lines) | YES | Partial | No | YES | No | No |
| Refactor (no behavior change) | No | YES | YES | No | Partial | No |
| Documentation only | No | No | No | No | YES | Partial |
| Config/build files | YES | No | No | No | No | Partial |
| Test files only | No | Partial | No | YES | No | No |
| Security-sensitive files | YES | Partial | No | YES | No | YES |

### Execution Modes

**Quick Review** (small/simple changes <20 lines)
- Run: Security + Testing only
- Skip: Detailed analysis, customer-obsession

**Standard Review** (default, 20-100 lines)
- Run: All relevant categories based on file types
- Use: Full checklists

**Deep Review** (major features >100 lines, breaking changes)
- Run: All categories including customer-obsession
- Add: Intent verification, cross-category analysis

---

## Standard Definitions

### Severity Levels

**Must Fix (Critical)**
- Security vulnerabilities (exploitable, data exposure)
- Bugs causing incorrect behavior
- Breaking functionality without migration path
- Missing tests for critical paths
- Intent mismatches causing bugs

**Should Fix (Medium)**
- Code quality issues (poor naming, unclear logic)
- Best practice violations
- Maintainability concerns
- Missing edge case tests
- Performance concerns
- Unclear or drifting intent

**Can Fix (Low)**
- Minor style issues
- Optional improvements
- Documentation enhancements
- Refactoring opportunities

### Reporting Format

For each finding, report:
1. **Location:** `file:line` or function name
2. **Category:** security | readability | simplicity | testing | documentation | customer
3. **Issue:** Brief description
4. **Impact:** Why it matters
5. **Fix:** Specific recommendation
6. **Severity:** Must Fix | Should Fix | Can Fix

### Git Commands Reference

```bash
# Repository check
git rev-parse --git-dir 2>/dev/null

# Staged changes
git diff --cached --stat          # Summary
git diff --cached                 # Full diff
git diff --cached --name-only     # File list
git diff --cached --name-status   # File status (A/M/D)
git diff --cached --shortstat     # Line counts

# Search patterns in staged changes
git diff --cached | grep -i -E "PATTERN" || true

# Find files by extension
git diff --cached --name-only | grep "\.ext$"

# Intent markers
git diff --cached | grep -i -E "(TODO|FIXME|NOTE)" || true
```

---

## Workflow

### Step 1: Analyze Change Context

1. **Verify git repository:**
   ```bash
   git rev-parse --git-dir 2>/dev/null || echo "Not a git repository"
   ```

2. **Gather change information:**
   ```bash
   git diff --cached --stat
   git diff --cached --name-status
   ```

3. **Determine execution mode** using conditional execution matrix above

4. **If no staged changes:** Ask user to stage files or review unstaged changes

### Step 2: Run Selected Review Agents

Run agents in parallel based on execution mode. Each category has one consolidated guide:

| Category | Guide File | Focus |
|----------|-----------|-------|
| Security | `security.md` | Vulnerabilities, OWASP, secrets, input validation |
| Readability | `readability.md` | Naming, structure, complexity, maintainability |
| Simplicity | `simplicity.md` | Over-engineering, abstractions, YAGNI/KISS |
| Testing | `testing.md` | Coverage, quality, edge cases, test structure |
| Documentation | `documentation.md` | Self-documenting code, comments, API docs |
| Customer | `customer-obsession.md` | Breaking changes, user impact, README/backlog |

**Agent instructions:**
- Load the relevant guide file
- Apply principles and checklist to staged changes
- Report findings in standard format
- Assign severity based on standard definitions

### Step 3: Intent Verification (Deep Review only)

For major changes, verify implementation matches intent:

1. **Infer intent** from function names, comments, commit messages
2. **Check alignment:**
   - Does code do what it claims?
   - Are there undocumented side effects?
   - Has intent drifted from original purpose?
3. **Report mismatches** as findings

### Step 4: Aggregate and Report

1. **Collect findings** from all agents
2. **Deduplicate** findings caught by multiple agents
3. **Generate report:**

```markdown
# Code Review Report

## Summary
- Files reviewed: [X]
- Lines changed: [+Y/-Z]
- Findings: [N] (Must: [A], Should: [B], Can: [C])

## Must Fix Issues
[Grouped by category]

## Should Fix Issues
[Grouped by category]

## Can Fix Issues
[Grouped by category]
```

4. **Ask user:**
   - "Fix Must Fix issues now?"
   - "Address Should Fix issues?"
   - "More details on any finding?"

---

## Guide Template

All category guides follow this standard structure:

```markdown
# [Category] Review Guide

## Quick Reference
[2-3 lines: Purpose + key question to ask]

## Principles
[4-6 principles with brief explanation - general reasoning/judgment guidance]

## Checklist
[Specific measurable items organized by area]
### [Area 1]
- [ ] Check item 1
- [ ] Check item 2

## Detection Patterns
[Category-specific git commands - avoid duplicating common commands from SKILL.md]

## Common Issues
[Frequent antipatterns to watch for]

## Examples
[1-2 concrete before/after examples]
```

**Key rules:**
- No redundant severity definitions (use SKILL.md)
- No redundant reporting format (use SKILL.md)
- Minimal git commands (only category-specific patterns)
- Cross-reference other guides when relevant

---

## Integration with Other Skills

- `git-commit` - Run review before commit workflow
- `thinking-partner` - For complex architectural decisions
- `documenting-tech-designs` - For design documentation needs

---

## Best Practices

1. **Use conditional execution** - Don't run all checks on all commits
2. **Run agents in parallel** - Efficiency matters
3. **Be thorough but targeted** - Review what's relevant
4. **Prioritize correctly** - Security issues are always Must Fix
5. **Provide actionable fixes** - Every finding needs a specific recommendation
6. **Deduplicate findings** - Same issue from multiple agents = one finding

## Anti-Patterns

| Anti-Pattern | Why It's Bad | Do Instead |
|--------------|--------------|------------|
| Running all agents on docs-only changes | Wastes time, irrelevant findings | Use conditional execution |
| Sequential agent execution | Slow, inefficient | Run in parallel |
| Vague findings ("code is unclear") | Not actionable | Specific issue + fix |
| Downgrading security issues | Risks exploitation | Security = Must Fix |
| Skipping customer impact on features | Breaks users, missing docs | Always check for features |

---

## Checklist

Before completing review:
- [ ] Execution mode determined (quick/standard/deep)
- [ ] Relevant agents run based on change type
- [ ] All findings captured with severity
- [ ] Intent verified (for deep reviews)
- [ ] Report generated and presented
- [ ] User asked about addressing findings
