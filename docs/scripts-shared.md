# Scripts Shared Documentation

This document provides an overview of all scripts in the `scripts-shared/` directory.

See also:
- [scripts.md](cursor://file/Users/omareid/Workspace/git/workspace/docs/scripts.md) - Main scripts directory

---

## Scripts

- [color](cursor://file/Users/omareid/Workspace/git/workspace/scripts-shared/color)
  - Provides color and formatting utilities for terminal output (ANSI codes, styles, colors)
- [date-deltas](cursor://file/Users/omareid/Workspace/git/workspace/scripts-shared/date-deltas)
  - Calculate date differences and deltas
- [find-links](cursor://file/Users/omareid/Workspace/git/workspace/scripts-shared/find-links)
  - Find and extract links from files
- [firefox-tabs](cursor://file/Users/omareid/Workspace/git/workspace/scripts-shared/firefox-tabs)
  - Manage Firefox browser tabs
- [html-decode](cursor://file/Users/omareid/Workspace/git/workspace/scripts-shared/html-decode)
  - Decode HTML entities to plain text
- [html-encode](cursor://file/Users/omareid/Workspace/git/workspace/scripts-shared/html-encode)
  - Encode text to HTML entities
- [interleave](cursor://file/Users/omareid/Workspace/git/workspace/scripts-shared/interleave)
  - Interleave lines from multiple inputs
- [lib.jq](cursor://file/Users/omareid/Workspace/git/workspace/scripts-shared/lib.jq)
  - Shared jq library functions
- [list-links](cursor://file/Users/omareid/Workspace/git/workspace/scripts-shared/list-links)
  - List all links found in files
- [noteplan](cursor://file/Users/omareid/Workspace/git/workspace/scripts-shared/noteplan)
  - NotePlan calendar and date utilities
- [parse-case](cursor://file/Users/omareid/Workspace/git/workspace/scripts-shared/parse-case)
  - Parse and convert text case formats
- [print-link](cursor://file/Users/omareid/Workspace/git/workspace/scripts-shared/print-link)
  - Print formatted link information
- [print-vscode-link](cursor://file/Users/omareid/Workspace/git/workspace/scripts-shared/print-vscode-link)
  - Print VSCode file links
- [resolve](cursor://file/Users/omareid/Workspace/git/workspace/scripts-shared/resolve)
  - Resolve file paths and links
- [search](cursor://file/Users/omareid/Workspace/git/workspace/scripts-shared/search)
  - Search utilities for files and content
- [sed-dates](cursor://file/Users/omareid/Workspace/git/workspace/scripts-shared/sed-dates)
  - Sed-based date manipulation and formatting
- [sed-dates-reducer](cursor://file/Users/omareid/Workspace/git/workspace/scripts-shared/sed-dates-reducer)
  - Reduce/aggregate date-based data
- [sed-dates.test](cursor://file/Users/omareid/Workspace/git/workspace/scripts-shared/sed-dates.test)
  - Tests for sed-dates functionality
- [validate-links](cursor://file/Users/omareid/Workspace/git/workspace/scripts-shared/validate-links)
  - Validate that links point to existing files
- [vscode-link](cursor://file/Users/omareid/Workspace/git/workspace/scripts-shared/vscode-link)
  - Generate VSCode file links

---

## Usage Examples

For detailed usage examples of each script, see [Makefile-scripts-shared](cursor://file/Users/omareid/Workspace/git/workspace/docs/Makefile-scripts-shared) in the docs directory.

You can run examples using:
```bash
make -f docs/Makefile-scripts-shared <script-name>
```
