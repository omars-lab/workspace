# NotePlan Organization Script - Implementation Plan

## Overview
Create a shell script that organizes NotePlan notes using `ccr code` (Claude Code Router) with local LLM. The script will use AI to determine file organization decisions and create move plans, but requires user approval before executing any changes.

**Key Design Principles:**
- Minimal LLM calls (local LLM is slow)
- AI focuses on decision-making and planning, not execution
- User has final approval on all operations
- Shell script (bash) for consistency with existing codebase

## Requirements
1. Script location: `/Users/omareid/Workspace/git/workspace/scripts/organize-noteplan.sh`
2. Prompts location: `/Users/omareid/Workspace/git/workspace/prompts/` (create if needed)
3. Plan document: `/Users/omareid/Workspace/git/workspace/docs/plans/` (exists)

## Implementation Plan

### Phase 1: Setup Structure
- [x] Scripts directory exists
- [ ] Create prompts directory if it doesn't exist
- [x] Docs/plans directory exists

### Phase 2: Prompt Files
Create the following prompt files in `/prompts/`:
1. `noteplan-organize-prompt.txt` - Main organization prompt for `ccr code`
   - Instructions for analyzing note content
   - Rules for determining target location
   - Output format specification (JSON)
2. `noteplan-structure-prompt.txt` - Folder structure rules
   - NotePlan directory structure (Calendar vs Notes)
   - Naming conventions
   - Date format requirements (YYYYMMDD.txt for Calendar)

### Phase 3: Main Script (`organize-noteplan.sh`)
Create shell script with:

#### Core Functionality:
1. **Argument Parsing**:
   - `--notes <path>` - Note file or directory to organize
   - `--dry-run` - Show plan without executing
   - `--interactive` - Interactive approval mode (default)
   - `--batch` - Process multiple files with single approval
   - `--help` - Show usage

2. **NotePlan Integration**:
   - Source `noteplan-helpers.sh` for date parsing functions
   - Use `${NOTEPLAN_ICLOUD_DIR}` from environment variables
   - Support both Calendar and Notes directories
   - Handle NotePlan date format (YYYYMMDD.txt)

3. **CCR Code Integration**:
   - Call `ccr code` with minimal context
   - Pass note content and organization prompt
   - Request JSON output with move plan
   - Handle slow local LLM responses gracefully

4. **User Approval Workflow**:
   - Display proposed move plan
   - Show file preview (source and destination)
   - Interactive prompts: `[y]es/[n]o/[s]kip/[a]ll/[q]uit`
   - Batch approval option
   - Confirmation before destructive operations

5. **Safety Features**:
   - Backup before moves (timestamped)
   - Dry-run mode
   - Log all operations
   - Error handling and rollback capability

6. **Output & Logging**:
   - Detailed operation log
   - Summary report
   - Error messages with context

### Phase 4: CCR Code Integration Details

#### Minimal LLM Call Strategy:
1. **Single Call Per File**:
   - Read note content
   - Call `ccr code` once with:
     - Note content (first N lines to limit context)
     - Organization prompt
     - Current file path
   - Request JSON response with move decision

2. **Expected Output Format**:
```json
{
  "should_move": true,
  "reason": "Brief explanation",
  "target_path": "Notes/Projects/ProjectName/filename.txt",
  "suggested_tags": ["tag1", "tag2"],
  "confidence": "high|medium|low"
}
```

3. **CCR Code Command Structure**:
```bash
ccr code --prompt-file "${PROMPT_FILE}" --input "${NOTE_CONTENT}" --output-format json
```

#### MCP/Tools Consideration:
- **Initial Assessment**: No MCP tools needed for basic file organization
- **Future Enhancement**: Could use file system MCP tools for:
  - Reading directory structures
  - Checking file existence
  - Validating paths
- **Decision**: Start without MCP tools, add if needed for complex scenarios

### Phase 5: User Approval Workflow

#### Interactive Mode (Default):
1. Script analyzes note with `ccr code`
2. Displays proposal:
   ```
   File: Calendar/20250113.txt
   Current: Calendar/20250113.txt
   Proposed: Notes/Projects/Work/20250113.txt
   Reason: Contains project planning content, not calendar entry
   Confidence: High
   
   [y]es  [n]o  [s]kip  [a]ll  [q]uit: 
   ```
3. User responds:
   - `y` - Execute move
   - `n` - Skip this file
   - `s` - Skip and continue
   - `a` - Approve all remaining
   - `q` - Quit without changes

#### Batch Mode:
1. Collect all proposals
2. Display summary table
3. Single approval for all operations
4. Option to review individual items

#### Dry-Run Mode:
- Show all proposals without execution
- Generate report file
- No user interaction required

### Phase 6: Testing
- [ ] Test with sample Calendar notes
- [ ] Test with sample Notes directory files
- [ ] Verify date format handling
- [ ] Test approval workflow
- [ ] Test error handling (file conflicts, invalid paths)
- [ ] Test backup and rollback
- [ ] Verify CCR code integration with local LLM

## Technical Details

### Dependencies:
- `bash` (shell script)
- `jq` (JSON parsing)
- `ccr` command (from `@musistudio/claude-code-router`)
- `noteplan-helpers.sh` (existing helper functions)
- Environment variables: `NOTEPLAN_ICLOUD_DIR`

### Script Features:

1. **Prompt Management**:
   - Load prompts from separate files
   - Support for different organization strategies via prompt variants
   - Minimal, focused prompts to reduce LLM processing time

2. **CCR Code Integration**:
   - Single call per file (minimize slow local LLM calls)
   - Structured JSON output for parsing
   - Error handling for LLM failures/timeouts
   - Context limiting (first 1000 chars of note)

3. **File Operations**:
   - Use existing NotePlan helper functions
   - Respect NotePlan file structure
   - Handle both Calendar (YYYYMMDD.txt) and Notes formats
   - Preserve file metadata where possible

4. **Safety & Backup**:
   - Create timestamped backup before any move
   - Backup location: `${DIR_FOR_BACKUPS}/noteplan-organize-$(date +%Y%m%d-%H%M%S)/`
   - Log all operations for audit trail
   - Rollback capability from backup

5. **Output & Reporting**:
   - Operation log file
   - Summary report (files moved, skipped, errors)
   - Console output with progress indicators

### Example Workflows:

#### Single File Organization:
```bash
organize-noteplan.sh --notes "${NOTEPLAN_ICLOUD_DIR}/Calendar/20250113.txt"
```

#### Directory Organization (Interactive):
```bash
organize-noteplan.sh --notes "${NOTEPLAN_ICLOUD_DIR}/Notes/Work"
```

#### Batch Mode:
```bash
organize-noteplan.sh --notes "${NOTEPLAN_ICLOUD_DIR}/Notes" --batch
```

#### Dry-Run:
```bash
organize-noteplan.sh --notes "${NOTEPLAN_ICLOUD_DIR}/Notes" --dry-run > organize-plan.txt
```

## File Structure

```
scripts/
  organize-noteplan.sh          # Main script
  noteplan-helpers.sh            # Existing helpers (source this)

prompts/
  noteplan-organize-prompt.txt   # Main organization prompt for ccr code
  noteplan-structure-prompt.txt  # Folder structure rules

docs/plans/
  noteplan-organization.md       # This file
```

## Decisions Made:

1. **Organization Strategies**: Start with content-based organization (analyze note content to determine best location)
2. **File Access**: Direct file system access (like existing scripts), not NotePlan API
3. **Backup Strategy**: Timestamped backups before any operation, stored in `${DIR_FOR_BACKUPS}`
4. **Dry-Run Mode**: Yes, essential for testing and preview
5. **MCP/Tools**: Not needed initially; can add file system MCP tools later if needed
6. **Script Language**: Shell script (bash) for consistency with codebase
7. **LLM Usage**: Minimal - single call per file, focused prompts, structured output

## Open Questions:

1. Should we support tag-based organization in addition to folder-based?
2. How should we handle notes that reference other notes (link preservation)?
3. Should we support custom organization rules/config files?
4. What's the maximum note size to send to LLM? (context limiting)
5. Should we cache LLM responses for identical notes?
