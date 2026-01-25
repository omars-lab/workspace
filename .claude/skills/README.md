# skill-asking-questions

A package for consolidating various skills for asking questions. This repository contains skills that help formulate effective questions at the right time and place.

## Structure

```
skills/
  asking-questions/
    Skill.md
```

## Building Skills

This project uses a Makefile to build and distribute skills as ZIP files for Claude.

### Available Commands

- `make` or `make all` - Build all skills (currently just asking-questions)
- `make build-asking-questions` - Build the asking-questions skill zip
- `make dist-asking-questions` - Alias for build-asking-questions
- `make clean` - Remove all distribution files
- `make help` - Show available commands

### Building a Skill

To build the asking-questions skill:

```bash
make build-asking-questions
```

This will create `dist/asking-questions.zip` which can be uploaded to Claude.

### Skill Structure

Each skill follows the [Claude Skills specification](https://docs.anthropic.com/claude/docs/skills):

- **Skill.md** - Required file with YAML frontmatter containing:
  - `name`: Human-friendly name (64 chars max)
  - `description`: Clear description of what the skill does (200 chars max)
  - Optional `dependencies` field for required packages
- **Additional files** - Can include reference files, scripts, or resources as needed

## Current Skills

### Asking Questions

Helps formulate effective questions at the right time and place to gather information, clarify understanding, and drive productive conversations.

## Future Distributions

The Makefile is designed to support multiple distribution formats. Currently, it builds ZIP files for Claude, but additional distribution targets can be added as needed.
