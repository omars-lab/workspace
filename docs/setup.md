# Setup Scripts Documentation

This document provides an overview of all scripts in the `setup/` directory.

See also:
- [scripts.md](cursor://file/Users/omareid/Workspace/git/workspace/docs/scripts.md) - Main scripts directory

---

## Scripts

- [setup-all.sh](cursor://file/Users/omareid/Workspace/git/workspace/setup/setup-all.sh)
  - Master setup script that runs all other setup scripts (brew, zsh, python, cron, iterm)
- [setup-apps.sh](cursor://file/Users/omareid/Workspace/git/workspace/setup/setup-apps.sh)
  - Install and configure applications
- [setup-binaries.sh](cursor://file/Users/omareid/Workspace/git/workspace/setup/setup-binaries.sh)
  - Install binary executables and tools
- [setup-brew.sh](cursor://file/Users/omareid/Workspace/git/workspace/setup/setup-brew.sh)
  - Install and configure Homebrew packages
- [setup-cron.sh](cursor://file/Users/omareid/Workspace/git/workspace/setup/setup-cron.sh)
  - Deploy and configure crontab jobs
- [setup-git.sh](cursor://file/Users/omareid/Workspace/git/workspace/setup/setup-git.sh)
  - Configure git settings and aliases
- [setup-link.sh](cursor://file/Users/omareid/Workspace/git/workspace/setup/setup-link.sh)
  - Create symlinks for configuration files
- [setup-python.sh](cursor://file/Users/omareid/Workspace/git/workspace/setup/setup-python.sh)
  - Install and configure Python environment
- [setup-zsh.sh](cursor://file/Users/omareid/Workspace/git/workspace/setup/setup-zsh.sh)
  - Install and configure zsh shell and plugins

---

## Usage Examples

For detailed usage examples of each script, see [Makefile-setup](cursor://file/Users/omareid/Workspace/git/workspace/docs/Makefile-setup) in the docs directory.

You can run examples using:
```bash
make -f docs/Makefile-setup <script-name>
```
