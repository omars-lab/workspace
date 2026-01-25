# Security Review Guide

## Quick Reference

Identify security vulnerabilities, unsafe patterns, and data exposure risks. Think like an attacker.

**Key question:** "How could this code be exploited or cause data exposure?"

## Principles

### 1. Defense in Depth
Multiple layers of security controls. Don't rely on a single measure. Fail securely (default deny).

### 2. Least Privilege
Code should only access what it needs. Users get minimal permissions. Services run with minimal privileges.

### 3. Input Validation
All user input is untrusted. Validate and sanitize everything. Use allowlists, not blocklists. Validate on both client and server.

### 4. Secure by Default
Secure configuration out of the box. Require explicit enabling of insecure features. Fail closed, not open.

### 5. Fail Securely
Handle errors without exposing sensitive information. Don't leak data in error messages. Log errors securely.

### 6. Secrets Management
Never hardcode secrets. Use environment variables or secret managers. Rotate credentials regularly.

## Checklist

### Authentication & Authorization
- [ ] No missing authorization checks before resource access
- [ ] No insecure direct object references (IDOR)
- [ ] No privilege escalation vulnerabilities
- [ ] Session management is secure
- [ ] Password handling follows best practices
- [ ] Multi-factor authentication where appropriate

### Secrets & Credentials (OWASP A02)
- [ ] No hardcoded API keys, passwords, or tokens
- [ ] No secrets in source code or committed config files
- [ ] No API keys exposed in client-side code
- [ ] No secrets in environment files committed to git
- [ ] Secrets stored in environment variables or secret managers
- [ ] No secrets in comments or documentation

### Injection (OWASP A03)
- [ ] No SQL injection (concatenated queries)
- [ ] No command injection (system, exec, shell_exec)
- [ ] No XSS vulnerabilities (reflected, stored, DOM-based)
- [ ] No template injection
- [ ] No NoSQL injection
- [ ] Parameterized queries used for database access

### Input Handling
- [ ] All user input validated before use
- [ ] Using allowlists instead of blocklists
- [ ] Server-side validation (not just client-side)
- [ ] Length limits enforced
- [ ] Type validation applied
- [ ] Input sanitized/escaped for output context

### Data Protection
- [ ] Sensitive data encrypted at rest
- [ ] Sensitive data encrypted in transit (HTTPS/TLS)
- [ ] Strong encryption algorithms used (not MD5, SHA1, DES, RC4)
- [ ] Proper key management
- [ ] Cryptographically secure random number generation
- [ ] No sensitive data exposure in URLs

### Error Handling & Logging (OWASP A09)
- [ ] No stack traces exposed to users
- [ ] No sensitive data in error messages
- [ ] No API keys, passwords, or tokens in logs
- [ ] No user PII logged unnecessarily
- [ ] Logs sanitized before writing (no log injection)
- [ ] Authentication failures logged without exposing credentials

### Configuration (OWASP A05)
- [ ] No default credentials
- [ ] Security headers set (X-Frame-Options, CSP, etc.)
- [ ] Debug mode disabled in production
- [ ] CORS properly configured
- [ ] Unnecessary features disabled

### File Operations
- [ ] No path traversal vulnerabilities
- [ ] File type validation for uploads
- [ ] File size limits enforced
- [ ] Uploaded files stored securely

### Deserialization
- [ ] No untrusted data deserialization
- [ ] Safe deserialization libraries used

## Detection Patterns

```bash
# Find hardcoded secrets (API keys, passwords, tokens)
git diff --cached | grep -i -E "(api[_-]?key|password|secret|token|credential).*[=:].*['\"]" | grep -v "test\|example\|mock" || true

# Find AWS credentials
git diff --cached | grep -i -E "(AKIA[0-9A-Z]{16}|aws[_-]?(access|secret)[_-]?key)" || true

# Find private keys
git diff --cached | grep -E "-----BEGIN.*PRIVATE KEY-----" || true

# Find potential SQL injection
git diff --cached | grep -i -E "(SELECT|INSERT|UPDATE|DELETE).*\+" || true

# Find command execution
git diff --cached | grep -i -E "\b(eval|exec|system|popen|shell_exec|subprocess)\s*\(" || true

# Find weak crypto
git diff --cached | grep -i -E "\b(md5|sha1)\s*\(" || true

# Find sensitive data in logs
git diff --cached | grep -i -E "log.*\.(info|error|warn|debug)\s*\(.*\b(password|secret|token|key|credential)" || true

# Find potential XSS (innerHTML, document.write)
git diff --cached | grep -i -E "(innerHTML|document\.write|\.html\()" || true
```

## Common Issues

| Issue | Risk | Fix |
|-------|------|-----|
| Hardcoded API key | Credential theft, unauthorized access | Use environment variables |
| SQL string concatenation | SQL injection | Use parameterized queries |
| eval() with user input | Code injection | Avoid eval, use safe alternatives |
| Missing authorization check | Privilege escalation | Check permissions before access |
| Sensitive data in logs | Data exposure | Sanitize logs, redact secrets |
| MD5/SHA1 for passwords | Weak hashing, crackable | Use bcrypt/argon2 |
| Missing input validation | Injection attacks | Validate all inputs |
| Debug mode in production | Information disclosure | Disable debug mode |

## Examples

### Example 1: Hardcoded Secret
```javascript
// BAD - Secret in code
const apiKey = "sk-1234567890abcdef";
fetch(url, { headers: { "Authorization": apiKey } });

// GOOD - Secret from environment
const apiKey = process.env.API_KEY;
if (!apiKey) throw new Error("API_KEY not configured");
fetch(url, { headers: { "Authorization": apiKey } });
```

### Example 2: SQL Injection
```python
# BAD - String concatenation
query = "SELECT * FROM users WHERE id = " + user_id
cursor.execute(query)

# GOOD - Parameterized query
query = "SELECT * FROM users WHERE id = %s"
cursor.execute(query, (user_id,))
```

### Example 3: Missing Authorization
```python
# BAD - No authorization check
@app.route("/user/<user_id>/data")
def get_user_data(user_id):
    return db.get_user_data(user_id)

# GOOD - Check ownership
@app.route("/user/<user_id>/data")
def get_user_data(user_id):
    if current_user.id != user_id and not current_user.is_admin:
        abort(403)
    return db.get_user_data(user_id)
```
