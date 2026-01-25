# Makefile for building and distributing Skills

SKILLS_DIR := skills
DIST_DIR := dist
ASKING_QUESTIONS_SKILL := asking-questions
ASKING_QUESTIONS_DIR := $(SKILLS_DIR)/$(ASKING_QUESTIONS_SKILL)

.PHONY: all clean build-asking-questions dist-asking-questions help

# Default target
all: dist-asking-questions

# Create distribution directory
$(DIST_DIR):
	@mkdir -p $(DIST_DIR)

# Build asking-questions skill zip
build-asking-questions: $(DIST_DIR)
	@echo "Building $(ASKING_QUESTIONS_SKILL).zip..."
	@cd $(SKILLS_DIR) && zip -r ../$(DIST_DIR)/$(ASKING_QUESTIONS_SKILL).zip $(ASKING_QUESTIONS_SKILL)/
	@echo "✓ Created $(DIST_DIR)/$(ASKING_QUESTIONS_SKILL).zip"

# Alias for build-asking-questions
dist-asking-questions: build-asking-questions

# Clean distribution files
clean:
	@echo "Cleaning distribution files..."
	@rm -rf $(DIST_DIR)
	@echo "✓ Cleaned $(DIST_DIR)"

# Help target
help:
	@echo "Available targets:"
	@echo "  all                    - Build all skills (default)"
	@echo "  build-asking-questions - Build asking-questions skill zip"
	@echo "  dist-asking-questions  - Alias for build-asking-questions"
	@echo "  clean                  - Remove all distribution files"
	@echo "  help                   - Show this help message"
