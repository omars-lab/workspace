---
name: git-commit
description: Inspect git changes, analyze quality, suggest improvements, and craft proper commit messages with user confirmation before committing.
---

# Git Commit Skill

## Purpose

This skill helps create well-crafted git commits by:
1. Inspecting all staged and unstaged changes
2. Analyzing the quality and completeness of changes
3. Identifying potential issues or improvements needed
4. Suggesting appropriate actions (including running other skills)
5. Crafting a proper commit message based on the changes
6. Confirming the commit message with the user before executing the commit

## When to Use This Skill

Use this skill when:
- The user wants to commit changes to git
- You need to help create a proper commit message
- You want to ensure code quality before committing
- The user asks about git commits or commit messages

## Workflow

### Step 1: Inspect Git Changes

**First, check the current git status and gather all relevant information:**

1. **Check if we're in a git repository:**
   ```bash
   git rev-parse --git-dir 2>/dev/null
   ```
   If this returns nothing, we're not in a git repository.

2. **Get current branch:**
   ```bash
   git branch --show-current
   ```

3. **Get full git status:**
   ```bash
   git status
   ```

4. **Get staged changes (what will be committed):**
   ```bash
   # Summary of staged changes
   git diff --cached --stat
   
   # Full diff of staged changes
   git diff --cached
   
   # List of staged files
   git diff --cached --name-only
   
   # Short summary (files changed, insertions, deletions)
   git diff --cached --shortstat
   
   # Show staged changes with more context
   git diff --cached -U3
   ```

5. **Get unstaged changes (what won't be committed):**
   ```bash
   # Short status format
   git status --short
   
   # Summary of unstaged changes
   git diff --stat
   
   # Full diff of unstaged changes
   git diff
   
   # List of unstaged files
   git diff --name-only
   ```

6. **Check if there are any staged changes:**
   ```bash
   # Returns exit code 0 if there are staged changes, 1 if none
   git diff --cached --quiet
   
   # Alternative: check if staging area is empty
   git diff --cached --exit-code
   ```

7. **Get detailed file information:**
   ```bash
   # Show what files are staged vs unstaged
   git status --porcelain
   
   # Show only staged files
   git diff --cached --name-status
   
   # Show only unstaged files
   git diff --name-status
   ```

**Important:** If there are no staged changes, inform the user and ask if they want to stage files first.

### Step 2: Analyze Changes

**Analyze the changes to understand:**
- What files were modified, added, or deleted
- What types of changes were made (features, bug fixes, refactoring, documentation, etc.)
- The scope and impact of changes
- Whether changes are related or should be split into multiple commits

**Use these commands to gather information:**
```bash
# See what files were added, modified, or deleted
git diff --cached --name-status

# Get a summary of changes by file type
git diff --cached --name-only | sed 's/.*\.//' | sort | uniq -c

# See the actual changes
git diff --cached
```

**Key questions to answer:**
- What is the primary purpose of these changes?
- Are all changes related to a single logical change?
- What problem does this commit solve?
- What is the impact of these changes?

### Step 3: Quality Assessment

**Check for potential quality issues using git commands:**

1. **Code Quality Issues:**

   **Search for TODOs, FIXMEs, and incomplete code:**
   ```bash
   # Search staged files for TODO/FIXME comments
   git diff --cached | grep -i -E "(TODO|FIXME|XXX|HACK|NOTE:)"
   
   # Search for TODO in staged file contents
   git diff --cached --name-only | xargs grep -i "TODO" 2>/dev/null || true
   ```

   **Search for debug code:**
   ```bash
   # Find console.log, print statements, debugger, etc. in staged files
   git diff --cached | grep -i -E "(console\.(log|debug|warn|error)|print\(|debugger|pdb\.set_trace)"
   
   # Search staged file contents
   git diff --cached --name-only | xargs grep -i -E "(console\.log|print\(|debugger)" 2>/dev/null || true
   ```

   **Search for commented-out code:**
   ```bash
   # Look for large blocks of commented code in staged changes
   git diff --cached | grep -E "^\+.*//|^\+.*#|^\+.*/\*"
   ```

   **Check for sensitive information:**
   ```bash
   # Search for potential secrets, passwords, API keys
   git diff --cached | grep -i -E "(password|secret|api[_-]?key|token|credential)" | grep -v "test\|example\|sample" || true
   
   # Check for hardcoded credentials
   git diff --cached --name-only | xargs grep -i -E "=.*['\"](password|secret|key|token)" 2>/dev/null || true
   ```

   **Other quality checks:**
   - Missing error handling
   - Inconsistent formatting or style
   - Potential bugs or logical issues

2. **Documentation Issues:**
   - Missing or incomplete documentation
   - Functions/classes without docstrings
   - Unclear variable or function names
   - Missing comments for complex logic

3. **Testing Issues:**

   **Check if test files are included:**
   ```bash
   # List staged test files
   git diff --cached --name-only | grep -i -E "(test|spec)" || echo "No test files staged"
   
   # Check if new source files have corresponding tests
   git diff --cached --name-only --diff-filter=A | grep -v -i -E "(test|spec)" | while read file; do
     # Check if corresponding test file exists
     test_file=$(echo "$file" | sed 's/\.\([^.]*\)$/_test.\1/')
     if [ ! -f "$test_file" ]; then
       echo "Warning: New file $file may need tests"
     fi
   done
   ```

   **Check for broken tests:**
   - Missing tests for new functionality
   - Broken tests
   - Test files not included in commit

4. **Commit Hygiene:**

   **Check commit size:**
   ```bash
   # Count files changed
   git diff --cached --name-only | wc -l
   
   # Count lines changed
   git diff --cached --shortstat
   
   # Get detailed change summary
   git diff --cached --stat
   ```

   **Check for unrelated changes:**
   ```bash
   # List all staged files to see if they're related
   git diff --cached --name-only
   
   # Show file types changed
   git diff --cached --name-only | sed 's/.*\.//' | sort | uniq -c
   ```

   **Check for large files:**
   ```bash
   # Check file sizes of staged files
   git diff --cached --name-only | xargs ls -lh 2>/dev/null | awk '{print $5, $9}'
   ```

   - Unrelated changes mixed together
   - Changes that should be split into multiple commits
   - Large commits that should be broken down
   - Sensitive information (passwords, keys, tokens) in code

5. **Project-Specific Issues:**
   - Missing required files (e.g., package.json updates, migration files)
   - Breaking changes without migration notes
   - Missing changelog updates

### Step 4: Suggest Improvements

**If quality issues are found, explicitly suggest actions:**

1. **List all identified issues clearly**

2. **For each issue, suggest specific actions:**
   - **Code quality issues:** Suggest running the `authoring-self-documenting-code` skill
   - **Documentation issues:** Suggest running the `authoring-self-documenting-code` skill or `documenting-tech-designs` skill
   - **Testing issues:** Suggest adding tests or fixing broken tests
   - **Commit hygiene:** Suggest splitting commits or staging/unstaging specific files
   - **Security issues:** Urgently flag and suggest immediate fixes

3. **Present options to the user:**
   ```
   I've identified the following issues:
   
   1. [Issue description]
      Suggested action: [Specific action, including skill to run if applicable]
   
   2. [Issue description]
      Suggested action: [Specific action]
   
   Would you like to:
   A) Fix these issues first (I can help with each one)
   B) Continue with the commit anyway
   C) Stage/unstage specific files to split this into multiple commits
   ```

4. **Wait for user's explicit choice before proceeding**

**If user wants to stage/unstage files, use these commands:**
```bash
# Stage specific files
git add <file1> <file2> <file3>

# Stage all changes
git add -A
# Or
git add .

# Unstage a file (keep changes)
git reset HEAD <file>

# Unstage all files (keep changes)
git reset HEAD

# Stage only part of a file (interactive)
git add -p <file>
```

### Step 5: Craft Commit Message

**Once quality is acceptable (or user chooses to proceed), craft a proper commit message:**

**Commit Message Format:**
- **Type:** Use conventional commit types (feat, fix, docs, style, refactor, test, chore, etc.)
- **Scope (optional):** The area of the codebase affected
- **Subject:** Clear, concise description (50 chars or less for first line)
- **Body (optional):** Detailed explanation (wrap at 72 chars)
- **Footer (optional):** Breaking changes, issue references

**Guidelines:**
- Use imperative mood ("Add feature" not "Added feature" or "Adds feature")
- First line should be a complete sentence
- Explain WHAT and WHY, not HOW (code shows how)
- Reference related issues or PRs
- Mention breaking changes if any

**Example format:**
```
feat(api): add user authentication endpoint

Implement JWT-based authentication for the API. This allows users
to securely log in and access protected resources.

- Add POST /auth/login endpoint
- Add JWT token generation and validation
- Update API documentation

Closes #123
```

### Step 6: Confirm Commit Message

**Before executing the commit, explicitly confirm with the user:**

1. **Present the proposed commit message:**
   ```
   Proposed commit message:
   
   [Show the full commit message]
   
   Would you like to:
   A) Use this message as-is
   B) Modify the message (tell me what to change)
   C) Start over with a different approach
   ```

2. **Wait for user confirmation or modification request**

3. **If user wants modifications, ask specific questions:**
   - "What would you like to change about the message?"
   - "Should I emphasize a different aspect?"
   - "Do you want to add more detail to the body?"
   - "Should I reference any issues or PRs?"

4. **Once confirmed, proceed with the commit**

### Step 7: Execute Commit

**After confirmation, execute the commit:**

**For simple single-line messages:**
```bash
git commit -m "feat(scope): subject line"
```

**For messages with body:**
```bash
git commit -m "feat(scope): subject line" -m "Body paragraph 1" -m "Body paragraph 2"
```

**For multi-line messages (using heredoc):**
```bash
git commit -m "feat(scope): subject line" -m "
Detailed body explanation here.
Can span multiple lines.

- Bullet point 1
- Bullet point 2

Closes #123
"
```

**Alternative using file (for complex messages):**
```bash
# Create temporary file with message
cat > /tmp/commit-msg.txt << 'EOF'
feat(scope): subject line

Detailed body explanation here.

- Bullet point 1
- Bullet point 2

Closes #123
EOF

# Commit using the file
git commit -F /tmp/commit-msg.txt

# Clean up
rm /tmp/commit-msg.txt
```

**After committing, verify and show results:**
```bash
# Show the commit that was just created
git log -1

# Show commit with file statistics
git log -1 --stat

# Show commit with full diff
git log -1 -p

# Show just the commit hash
git rev-parse HEAD

# Show commit in one line format
git log -1 --oneline

# Show commit message only
git log -1 --pretty=format:"%s%n%n%b"
```

**Confirm the commit was successful:**
- Show the commit hash: `git rev-parse HEAD`
- Show commit summary: `git log -1 --stat`
- Show commit message: `git log -1 --pretty=format:"%s%n%n%b"`

## Special Cases

### No Staged Changes

If there are no staged changes, check with:
```bash
# Check if staging area is empty
git diff --cached --quiet && echo "No staged changes" || echo "Has staged changes"

# Show current status
git status
```

Then inform the user:
```
I notice there are no staged changes to commit. 

Current status:
[Show git status output]

Would you like to:
A) Stage specific files (tell me which ones)
   Command: git add <file1> <file2> ...
B) Stage all changes
   Command: git add -A
   Or: git add .
C) Cancel
```

### Unstaged Changes Present

If there are unstaged changes, check with:
```bash
# Check for unstaged changes
git diff --quiet && echo "No unstaged changes" || echo "Has unstaged changes"

# Show unstaged files
git diff --name-only

# Show unstaged changes summary
git diff --stat
```

Then inform the user:
```
Note: You have unstaged changes that won't be included in this commit:
[Show unstaged files from: git diff --name-only]

The commit will only include:
[Show staged files from: git diff --cached --name-only]

Is this intentional, or would you like to stage additional files?
To stage specific files: git add <file1> <file2>
To stage all: git add -A
```

### Mixed Changes (Some Staged, Some Unstaged)

Always inform the user about what will and won't be committed. Use these commands:
```bash
# Show full status
git status

# Show staged files
git diff --cached --name-only
git diff --cached --stat

# Show unstaged files
git diff --name-only
git diff --stat
```

Then present:
```
Staged changes (will be committed):
[Show output from: git diff --cached --name-only and git diff --cached --stat]

Unstaged changes (will NOT be committed):
[Show output from: git diff --name-only and git diff --stat]
```

### Large Commit

If the commit is very large (many files or many lines):
```bash
# Count files
git diff --cached --name-only | wc -l

# Get line count summary
git diff --cached --shortstat
```

Then inform the user:
```
This is a large commit with [X] files and [Y] lines changed.

Consider splitting this into smaller, focused commits:
- [Suggestion 1]
- [Suggestion 2]

Would you like to:
A) Proceed with this large commit
B) Help split this into smaller commits
```

## Integration with Other Skills

**When suggesting improvements, explicitly mention relevant skills:**

- **Code quality/documentation:** "I suggest running the `authoring-self-documenting-code` skill to improve code documentation"
- **Design documentation:** "Consider using the `documenting-tech-designs` skill to document this design change"
- **Complex changes:** "This is a significant change - would you like to use the `thinking-partner` skill to explore the approach?"

## Best Practices

1. **Always inspect before committing** - Never commit without understanding what's changing
2. **Be thorough in analysis** - Look for both obvious and subtle issues
3. **Be explicit about suggestions** - Clearly state what's wrong and how to fix it
4. **Respect user choice** - If user wants to proceed despite issues, honor that choice
5. **Confirm before committing** - Never commit without explicit user confirmation of the message
6. **Provide context** - Help user understand what they're committing and why

## Examples

### Example 1: Clean Commit

**User:** "Commit these changes"

**Process:**
1. Inspect:
   ```bash
   git diff --cached --stat
   # Output: 3 files changed, 45 insertions(+), 12 deletions(-)
   ```
2. Analyze: New authentication feature, well-structured code
3. Quality: No issues found
4. Craft message: "feat(auth): add JWT authentication"
5. Confirm: User approves
6. Commit:
   ```bash
   git commit -m "feat(auth): add JWT authentication"
   ```
7. Verify:
   ```bash
   git log -1 --stat
   ```

### Example 2: Issues Found

**User:** "Commit these changes"

**Process:**
1. Inspect:
   ```bash
   git diff --cached --stat
   # Output: 5 files changed, 120 insertions(+), 45 deletions(-)
   ```
2. Analyze: Feature addition but incomplete
3. Quality check:
   ```bash
   git diff --cached | grep -i "TODO"
   # Found 3 TODOs
   git diff --cached | grep -i "console.log"
   # Found 2 console.log statements
   ```
4. Suggest: "Found incomplete code. Suggest running `authoring-self-documenting-code` skill. Continue anyway?"
5. User: "Fix them first"
6. Help fix issues, then proceed with commit:
   ```bash
   git commit -m "feat(api): add user authentication" -m "Implement JWT-based auth with token validation"
   ```

### Example 3: Unrelated Changes

**User:** "Commit these changes"

**Process:**
1. Inspect:
   ```bash
   git diff --cached --name-only
   # Output shows 8 files: mix of feature and bug fix
   git diff --cached --stat
   ```
2. Analyze: Two unrelated changes
3. Quality: Should be split
4. Suggest: "These changes are unrelated. Split into 2 commits?"
5. User: "Yes, split them"
6. Help stage/unstage appropriately:
   ```bash
   # Unstage all first
   git reset HEAD
   
   # Stage only bug fix files
   git add bug-fix-file1.js bug-fix-file2.js
   
   # Create first commit
   git commit -m "fix: resolve authentication bug"
   
   # Stage feature files
   git add feature-file1.js feature-file2.js feature-file3.js
   
   # Create second commit
   git commit -m "feat: add user dashboard"
   ```

## Checklist

Before committing, ensure:
- [ ] All staged changes have been inspected using `git diff --cached`
- [ ] Changes have been analyzed for purpose and scope
- [ ] Quality issues have been identified using git commands and addressed (or user chose to proceed)
- [ ] Commit message has been crafted following best practices
- [ ] Commit message has been confirmed by user
- [ ] User understands what will be committed
- [ ] Any unstaged changes are intentional

## Anti-Patterns to Avoid

❌ **Committing without inspection:** "I'll commit these changes" (without checking what they are using `git diff --cached`)

❌ **Ignoring quality issues:** Proceeding with commit despite obvious problems found in git diff

❌ **Not confirming message:** Committing with a message the user hasn't approved

❌ **Assuming user intent:** Making decisions about what to commit without asking

❌ **Rushing the process:** Not giving user time to review and make decisions

❌ **Not using explicit git commands:** Using vague descriptions instead of showing exact commands

Remember: **A good commit message is a gift to your future self and your team.** Take the time to do it right, and always use explicit git commands to inspect and verify changes.
