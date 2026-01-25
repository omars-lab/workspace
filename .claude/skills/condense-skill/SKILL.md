---
name: condense-skill
description: Condenses verbose skills into concentrated, actionable guidance while preserving all essential knowledge. Like condensed milk - removes the water, keeps the nutrition. Use when skills are too long, have redundant content, or need streamlining.
link: not
---

# Condensing Skills

## Triggering Criteria

Users can trigger this skill by saying:
- "Condense this skill"
- "This skill is too long"
- "Streamline this skill"
- "Make this skill more concise"
- Or using: `/condense-skill`

## The Condensed Milk Analogy

| Aspect | Milk → Condensed Milk | Skill → Condensed Skill |
|--------|----------------------|------------------------|
| **Remove** | Water (60% of volume) | Redundancy, verbose examples, repeated concepts |
| **Keep** | All nutrition, flavor, essence | Core workflow, key concepts, intent, essential knowledge |
| **Result** | Concentrated, shelf-stable | Concentrated, scannable, actionable |
| **Usage** | Dilute when needed | Reference guides/ for details |

**Key insight**: Condensation ≠ deletion. You're concentrating, not removing nutrition.

## When to Condense

- [ ] **Too long** - SKILL.md >200 lines
- [ ] **Redundant** - Same concept in multiple places
- [ ] **Verbose examples** - Could be in guides/
- [ ] **Duplicate files** - Multiple files, same content
- [ ] **Hard to scan** - Can't grasp workflow in 30 seconds

## Condensation Process

### Phase 1: Analyze
1. Count lines in all skill files
2. Identify the intent - what does this skill help users do?
3. Map essential knowledge - what MUST be preserved?
4. Find redundancy - duplicates, verbose explanations, inline examples

### Phase 2: Extract Before Condensing
Document what MUST stay vs what CAN move to guides:

| MUST Preserve in SKILL.md | CAN Move to guides/ |
|---------------------------|---------------------|
| Core intent/purpose | Step-by-step details |
| Key concepts (as tables) | Verbose examples |
| Decision frameworks | Edge cases |
| Essential workflow/checklist | Templates |
| Critical warnings | Boilerplate |

### Phase 3: Restructure SKILL.md

Target structure (100-200 lines):
```
---
name/description/link (frontmatter)
---
# Title
## Triggering Criteria     ← HOW users invoke it
## Key Concepts            ← Tables > paragraphs (5-10 lines)
## When to Use             ← Checklist (3-5 items)
## Workflow                ← Core process (10-20 lines)
## Key Principles          ← Numbered list (3-7 items)
## Detailed Guides         ← Links to guides/
```

### Phase 4: Move Details to Guides
Create `guides/[topic].md` for detailed reference material.

### Phase 5: Validate
- [ ] Intent preserved? Still conveys what skill does?
- [ ] Knowledge preserved? Essential concepts accessible?
- [ ] Scannable? Grasp workflow in 30 seconds?
- [ ] Actionable? Can use skill with just SKILL.md?

## Condensation Techniques

| Technique | Example |
|-----------|---------|
| **Tables > Paragraphs** | 3 paragraphs → 1 table |
| **Checklists > Prose** | "First... then..." → `- [ ] Step` |
| **Links > Inline** | Full examples → "See guides/" |
| **Delete duplicates** | SKILL.md + prompt.md → Just SKILL.md |

## What NOT to Remove

**Never condense away:**
- Core intent/purpose of the skill
- Key decision frameworks (when to use what)
- Critical warnings or gotchas
- Essential workflow/checklist
- Triggering criteria and frontmatter

**Test**: If removing requires users to "just know" it, keep it.

## Target Metrics

| Component | Lines | Purpose |
|-----------|-------|---------|
| **SKILL.md** | 100-200 | Core workflow, scannable |
| **Each guide** | 200-800 | Detailed reference |
| **Total** | <2,000 | Comprehensive but focused |

## Key Principles

1. **Concentrate, don't delete** - Nutrition stays, water goes
2. **Tables > paragraphs** - Visual scanning beats reading
3. **Checklists > prose** - Actionable beats descriptive
4. **Single source of truth** - No duplicate explanations
5. **Preserve intent & knowledge** - The "why" and key concepts must survive
6. **Frontmatter matters** - name, description, triggering criteria are essential
