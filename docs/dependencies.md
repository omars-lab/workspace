# Workspace Dependencies

This document lists all dependencies assumed by the workspace environment, their installation status in setup scripts, and whether they're required or optional.

## Dependency Analysis

### Core System Dependencies

| Dependency | Used In | Setup Script | Status | Required |
|------------|---------|--------------|--------|----------|
| **Homebrew** | `loader-personal.sh`, `zshrc` | `setup-brew.sh` | ✅ Installed | ✅ Required |
| **Python 3** | `common.sh` (timing), `zshrc` | ❌ Not installed | ❌ Missing | ✅ Required |
| **bc** | `common.sh` (duration calc) | ❌ Not installed | ❌ Missing | ✅ Required |
| **jq** | `zshrc` (conda env check) | ❌ Commented out | ❌ Missing | ✅ Required |

### Shell & Terminal

| Dependency | Used In | Setup Script | Status | Required |
|------------|---------|--------------|--------|----------|
| **Oh My Zsh** | `zshrc` | `setup-zsh.sh` | ✅ Installed | ✅ Required |
| **Antigen** | `zshrc` | `setup-zsh.sh` | ✅ Installed | ✅ Required |
| **zsh-completions** | `zshrc` | `setup-zsh.sh` | ✅ Installed | ✅ Required |
| **Auto Jump** | `zshrc` | ❌ Commented out | ❌ Missing | ⚠️ Optional |
| **iTerm2 Integration** | `zshrc` | `setup-all.sh` | ✅ Installed | ⚠️ Optional |

### Version Managers

| Dependency | Used In | Setup Script | Status | Required |
|------------|---------|--------------|--------|----------|
| **ASDF** | `zshrc` | ❌ Commented out | ❌ Missing | ⚠️ Optional |
| **NVM** | `zshrc`, `setup-all.sh` | ❌ Commented out | ❌ Missing | ⚠️ Optional |
| **Conda** | `zshrc`, `setup-python.sh` | ❌ Assumed installed | ❌ Missing | ✅ Required |

### Development Tools

| Dependency | Used In | Setup Script | Status | Required |
|------------|---------|--------------|--------|----------|
| **Docker** | `zshrc` (completions) | ❌ Not installed | ❌ Missing | ⚠️ Optional |
| **Maven** | `zshrc` (M2_HOME) | ❌ Commented out | ❌ Missing | ⚠️ Optional |

### Optional Workspaces

| Dependency | Used In | Setup Script | Status | Required |
|------------|---------|--------------|--------|----------|
| **Career Workspace** | `zshrc` | ❌ Not installed | ❌ Missing | ⚠️ Optional |

## Summary

### Required Dependencies Missing from Setup
1. **Python 3** - Used in `common.sh` for timing calculations
2. **bc** - Used in `common.sh` for duration calculations  
3. **jq** - Used in `zshrc` for conda environment checking
4. **Conda** - Assumed to exist but not installed by setup scripts

### Optional Dependencies Missing from Setup
1. **Auto Jump** - Referenced in `zshrc` but commented out in `setup-brew.sh`
2. **ASDF** - Referenced in `zshrc` but commented out in `setup-brew.sh`
3. **NVM** - Referenced in `zshrc` but commented out in `setup-brew.sh`
4. **Docker** - Completions referenced in `zshrc` but not installed

## Recommendations

1. **Add dependency checks to loader** - Check for required dependencies before sourcing
2. **Install missing required deps** - Add Python 3, bc, jq to setup scripts
3. **Install Conda** - Add conda installation to `setup-python.sh` or document requirement
4. **Uncomment optional deps** - Consider uncommenting Auto Jump, ASDF, NVM in `setup-brew.sh` if commonly used

## Usage

Check dependencies:
```bash
./setup/check-dependencies.sh
```

Check and install missing dependencies:
```bash
./setup/check-dependencies.sh --install
```
