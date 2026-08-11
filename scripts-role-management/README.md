# Scripts

Central location for all automation scripts. Roles reference these scripts but don't contain them.

## Principle

- **Scripts + Outputs** → This repo (`/scripts/`)
- **Role artifacts** → Reference scripts, don't contain them

Each script directory contains its own `outputs/` folder for generated files. Roles link to these outputs rather than duplicating them.

## Structure

```
scripts/
├── README.md             # This file
├── [role-name]/          # Scripts organized by role
│   └── [script-name]/    # Each script in its own directory
│       ├── script.sh     # The script itself
│       ├── README.md     # Usage documentation (optional)
│       ├── inputs/       # Input files/templates (if needed)
│       └── outputs/      # Generated outputs
└── shared/               # Scripts used across multiple roles
```

## Role Scripts

### automator/

Scripts for The Automator role - auto-generation and automation.

| Script | Purpose | Output |
|--------|---------|--------|
| [listing-experiments/](automator/listing-experiments/) | Scan codebase for "Tinker with" files and generate overview | `outputs/Overview.md` |
| [listing-learning-objectives/](automator/listing-learning-objectives/) | Generate PlantUML diagram of learning objectives | `outputs/*.puml, *.svg` |
| [listing-managed-entities/](automator/listing-managed-entities/) | Generate PlantUML diagram of managed entities | `outputs/*.puml, *.svg` |
| [noteplan-sync/](automator/noteplan-sync/) | Sync question structure with Noteplan | `outputs/noteplan-structure.txt` |

### Root Scripts
Legacy scripts for role management:

| Script | Purpose |
|--------|---------|
| activity-history.sh | Track activity history |
| role-metrics.sh | Calculate role metrics |
| role-refactoring.sh | Help with role refactoring |
| managing-links.sh | Manage links |
| fix-permissions.sh | Fix file permissions |

## TODOs

- [ ] Should I move these over to my cli?
	- [ ] Make a script to help derive vscode links for a directory ...
	- [ ] Make a script to tell me which initiatives are missing a front matter header
	- [ ] Make a script to tell me which files are big / have lots of tasks and which ones are small ...
	- [ ] Make a script to tell me which files have "needs" / "habits"
	- [ ] Make a script to find all the learning tasks ...
	- [ ] Make a script to group initiatives ...
		- [ ] If I make flat initiatives ... probably going to end up going back to a hats like structure ... at the same time its nice to have a flat list of initiatives ... all learning initiatives ... etc ...
	- [ ] Make a script to help reduce initiatives ...
		- [ ] I should find initiatives with similar learning tasks ...
	- [ ] Figure out how to orchestrate these scripts ...
