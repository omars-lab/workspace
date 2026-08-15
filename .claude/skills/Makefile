# Package the skills in this directory as ZIPs.
#
# This is NOT how the skills run. Claude Code reads .claude/skills/<name>/SKILL.md
# directly out of the repo, with no build step. The zips are only for handing a
# skill to something that cannot read this repo — uploading to claude.ai.
#
# Skills are discovered, not listed: any directory holding a SKILL.md is one, so
# adding a skill needs no edit here.

SKILLS := $(sort $(patsubst %/,%,$(dir $(wildcard */SKILL.md))))
DIST   := dist

# dist-<skill> is deliberately NOT .PHONY: make skips implicit-rule search for
# phony targets, so declaring them would leave the pattern rule below unused
# ("nothing to be done"). Nothing ever creates a file named dist-<skill>, so
# they rebuild every time regardless.
.PHONY: all list clean help

all: $(addprefix dist-,$(SKILLS))

list:
	@printf '%s\n' $(SKILLS)

$(DIST):
	@mkdir -p $(DIST)

# dist-<skill> -> dist/<skill>.zip, rebuilt from scratch each time so a removed
# file cannot survive inside an old archive.
dist-%: | $(DIST)
	@test -f $*/SKILL.md || { echo "no such skill: $*" >&2; exit 1; }
	@rm -f $(DIST)/$*.zip
	@zip -qr $(DIST)/$*.zip $*/
	@echo "✓ $(DIST)/$*.zip"

clean:
	@rm -rf $(DIST)
	@echo "✓ cleaned $(DIST)"

help:
	@echo "make list          - list the skills in this directory"
	@echo "make dist-<skill>  - package one skill into $(DIST)/<skill>.zip"
	@echo "make all           - package every skill"
	@echo "make clean         - remove $(DIST)/"
