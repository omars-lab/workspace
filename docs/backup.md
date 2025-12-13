# Backup Scripts Documentation

This document provides an overview of all scripts in the `backup/` directory.

See also:
- [scripts.md](cursor://file/Users/omareid/Workspace/git/workspace/docs/scripts.md) - Main scripts directory

---

## Scripts

- [backup-laptop.sh](cursor://file/Users/omareid/Workspace/git/workspace/backup/backup-laptop.sh)
  - Backup laptop configuration, dotfiles, and system information to a unique directory
- [icloud-sync](cursor://file/Users/omareid/Workspace/git/workspace/backup/icloud-sync)
  - Sync files with iCloud storage
- [reload-laptop-one-time.sh](cursor://file/Users/omareid/Workspace/git/workspace/backup/reload-laptop-one-time.sh)
  - One-time setup script for reloading laptop configuration
- [reload-laptop.sh](cursor://file/Users/omareid/Workspace/git/workspace/backup/reload-laptop.sh)
  - Reload laptop configuration from backup

---

## Usage Examples

For detailed usage examples of each script, see [Makefile-backup](cursor://file/Users/omareid/Workspace/git/workspace/docs/Makefile-backup) in the docs directory.

You can run examples using:
```bash
make -f docs/Makefile-backup <script-name>
```
