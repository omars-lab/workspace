# Document Splitter Component - Detailed Design

**Author**: Engineering Team  
**Date**: 2025-01-XX  
**Status**: Detailed Design - Component Specification  
**Version**: 1.0  
**Parent Design**: `noteplan-organization.md`

## Overview

The Document Splitter is a critical component that parses markdown documents (daily notes) into a structured hierarchy of sections, subsections, and items. It enables the organization system to identify extractable content units and understand document structure for intelligent content extraction.

## Problem Statement

Daily notes contain mixed content organized in markdown format:
- Frontmatter (YAML metadata block)
- Multiple top-level headings (`# Heading`)
- Subheadings (`## Subheading`, `### Sub-subheading`)
- Bullet point lists under headings
- Indented items/subtasks under bullet points
- Context text between items

**Challenge**: Need to parse this structure to:
1. Identify logical content boundaries (what can be extracted together)
2. Understand hierarchical relationships (section → subsection → item)
3. Detect when splitting a subsection would break context
4. Enable easy review of what can be moved

## Document Structure Model

### Example Daily Note Structure

```markdown
---
title: "Daily Notes - 2025-01-13"
tags: [work, personal]
---

# Work

## Project X Planning Meeting

Discussed roadmap for Q2:
- Feature A: High priority
  - Design mockups needed
  - Engineering estimate: 2 weeks
- Feature B: Deferred
  - Waiting on stakeholder feedback

## Project Y Review

Status update:
- Sprint planning complete
- Blockers identified

# Personal

## Todos

- [ ] Buy groceries
  - Milk
  - Bread
- [ ] Call dentist
  - Schedule cleaning
  - Ask about insurance

## Ideas

Random thought about productivity...
```

### Parsed Structure

```json
{
  "document": {
    "path": "Calendar/20250113.txt",
    "frontmatter": {
      "title": "Daily Notes - 2025-01-13",
      "tags": ["work", "personal"]
    },
    "sections": [
      {
        "id": "sect-001",
        "level": 1,
        "heading": "# Work",
        "line_start": 6,
        "line_end": 20,
        "subsections": [
          {
            "id": "subsect-001",
            "level": 2,
            "heading": "## Project X Planning Meeting",
            "line_start": 8,
            "line_end": 15,
            "items": [
              {
                "id": "item-001",
                "type": "bullet",
                "content": "Feature A: High priority",
                "line_start": 10,
                "line_end": 12,
                "indented_items": [
                  {
                    "id": "item-001-1",
                    "type": "bullet",
                    "content": "Design mockups needed",
                    "line_start": 11,
                    "indent_level": 2
                  },
                  {
                    "id": "item-001-2",
                    "type": "bullet",
                    "content": "Engineering estimate: 2 weeks",
                    "line_start": 12,
                    "indent_level": 2
                  }
                ]
              },
              {
                "id": "item-002",
                "type": "bullet",
                "content": "Feature B: Deferred",
                "line_start": 13,
                "line_end": 14,
                "indented_items": [
                  {
                    "id": "item-002-1",
                    "type": "bullet",
                    "content": "Waiting on stakeholder feedback",
                    "line_start": 14,
                    "indent_level": 2
                  }
                ]
              }
            ],
            "context": "Discussed roadmap for Q2:"
          }
        ]
      }
    ]
  }
}
```

## Component Architecture

### Input
- Markdown document (daily note file)
- File path for reference

### Output
- Structured JSON representation of document hierarchy
- Section/subsection/item boundaries with line numbers
- Relationship mapping (parent-child, sibling relationships)
- Extractability flags (can this be moved independently?)

### Processing Steps

1. **Frontmatter Extraction**
   - Detect YAML frontmatter block (`---` delimiters)
   - Parse YAML content
   - Store separately from markdown content

2. **Heading Detection**
   - Scan for markdown headings (`# Heading`, `## Subheading`, etc.)
   - Track heading levels (1-6)
   - Record line numbers

3. **Section Hierarchy Building**
   - Build tree structure based on heading levels
   - Parent-child relationships: level 1 → level 2 → level 3
   - Sibling relationships: same level, sequential

4. **Content Assignment**
   - Assign content between headings to appropriate sections
   - Handle:
     - Paragraphs before first heading
     - Paragraphs between headings
     - Lists under headings
     - Indented content

5. **Item Parsing**
   - Identify bullet points (`-`, `*`, `+`)
   - Identify numbered lists
   - Identify task items (`- [ ]`, `- [x]`)
   - Track indentation levels
   - Parse indented sub-items

6. **Context Detection**
   - Identify context text (non-list content)
   - Associate context with nearest heading/item
   - Detect when context is shared across items

7. **Extractability Analysis**
   - Determine if section can be extracted independently
   - Check dependencies:
     - Does it reference parent section context?
     - Are there cross-references to other sections?
     - Would extraction break document flow?

## Data Structures

### Section Node

```typescript
interface SectionNode {
  id: string;                    // Unique identifier
  level: number;                 // Heading level (1-6)
  heading: string;              // Full heading text with markers
  heading_text: string;         // Heading text without markers
  line_start: number;            // Starting line number
  line_end: number;              // Ending line number
  content_start: number;         // First content line (after heading)
  content_end: number;           // Last content line
  parent_id: string | null;      // Parent section ID
  children: string[];            // Child section IDs
  items: ItemNode[];             // Items under this section
  context: string | null;        // Context text before items
  extractable: boolean;          // Can this be extracted independently?
  extraction_dependencies: string[]; // IDs of sections that must be extracted together
}
```

### Item Node

```typescript
interface ItemNode {
  id: string;                    // Unique identifier
  type: "bullet" | "numbered" | "task" | "paragraph";
  content: string;               // Item content
  line_start: number;            // Starting line number
  line_end: number;              // Ending line number
  indent_level: number;          // Indentation level (0 = top level)
  parent_item_id: string | null; // Parent item ID (for nested items)
  children: string[];            // Child item IDs
  context: string | null;        // Context text associated with item
  extractable: boolean;          // Can this item be extracted independently?
}
```

### Document Structure

```typescript
interface DocumentStructure {
  path: string;
  frontmatter: Record<string, any> | null;
  sections: SectionNode[];
  items: ItemNode[];            // Flat list of all items
  metadata: {
    total_lines: number;
    total_sections: number;
    total_items: number;
    parse_timestamp: string;
    parser_version: string;
  };
}
```

## Parsing Algorithm

### Phase 1: Lexical Analysis

```python
def parse_markdown(document: str) -> DocumentStructure:
    lines = document.split('\n')
    
    # Extract frontmatter
    frontmatter, content_start = extract_frontmatter(lines)
    
    # Build heading map
    headings = detect_headings(lines, content_start)
    
    # Build section hierarchy
    sections = build_section_hierarchy(headings, lines)
    
    # Parse items within sections
    for section in sections:
        section.items = parse_items_in_section(section, lines)
        section.context = extract_context(section, lines)
    
    # Analyze extractability
    analyze_extractability(sections)
    
    return DocumentStructure(
        frontmatter=frontmatter,
        sections=sections,
        items=flatten_items(sections),
        metadata=compute_metadata(lines, sections)
    )
```

### Phase 2: Hierarchy Building

```python
def build_section_hierarchy(headings: List[Heading], lines: List[str]) -> List[SectionNode]:
    stack = []  # Stack of parent sections
    sections = []
    
    for heading in headings:
        # Pop stack until we find parent at correct level
        while stack and stack[-1].level >= heading.level:
            stack.pop()
        
        section = SectionNode(
            id=f"sect-{len(sections):03d}",
            level=heading.level,
            heading=heading.full_text,
            heading_text=heading.text,
            line_start=heading.line_number,
            parent_id=stack[-1].id if stack else None
        )
        
        if stack:
            stack[-1].children.append(section.id)
        
        stack.append(section)
        sections.append(section)
    
    # Set line_end for each section
    for i, section in enumerate(sections):
        if i + 1 < len(sections):
            section.line_end = sections[i + 1].line_start - 1
        else:
            section.line_end = len(lines)
    
    return sections
```

### Phase 3: Item Parsing

```python
def parse_items_in_section(section: SectionNode, lines: List[str]) -> List[ItemNode]:
    items = []
    current_item = None
    
    for line_num in range(section.content_start, section.content_end + 1):
        line = lines[line_num]
        indent = get_indent_level(line)
        
        if is_bullet_point(line):
            # New top-level item
            if current_item:
                items.append(current_item)
            
            current_item = ItemNode(
                id=f"item-{section.id}-{len(items):03d}",
                type=detect_item_type(line),
                content=extract_item_content(line),
                line_start=line_num,
                indent_level=indent
            )
        elif is_indented_content(line, current_item):
            # Sub-item or context
            if is_bullet_point(line):
                sub_item = ItemNode(
                    id=f"item-{current_item.id}-{len(current_item.children):03d}",
                    type=detect_item_type(line),
                    content=extract_item_content(line),
                    line_start=line_num,
                    indent_level=indent,
                    parent_item_id=current_item.id
                )
                current_item.children.append(sub_item.id)
            else:
                # Context text
                if not current_item.context:
                    current_item.context = ""
                current_item.context += line.strip() + "\n"
        elif line.strip():
            # Paragraph context
            if not section.context:
                section.context = ""
            section.context += line.strip() + "\n"
    
    if current_item:
        items.append(current_item)
    
    return items
```

### Phase 4: Extractability Analysis

```python
def analyze_extractability(sections: List[SectionNode]) -> None:
    for section in sections:
        # Check if section has dependencies
        dependencies = []
        
        # Check parent context dependency
        if section.parent_id:
            parent = find_section(section.parent_id, sections)
            if parent.context and section.references_parent_context():
                dependencies.append(section.parent_id)
        
        # Check sibling dependencies
        siblings = get_siblings(section, sections)
        for sibling in siblings:
            if section.cross_references(sibling):
                dependencies.append(sibling.id)
        
        section.extraction_dependencies = dependencies
        section.extractable = len(dependencies) == 0
```

## Extraction Unit Identification

### Extraction Units

The parser identifies different levels of extractable units:

1. **Full Section** (Level 1 heading + all children)
   - Example: Entire "# Work" section
   - Extractable if: No dependencies on other sections

2. **Subsection** (Level 2+ heading + children)
   - Example: "## Project X Planning Meeting"
   - Extractable if: No dependencies on parent section context

3. **Item Group** (Multiple related items)
   - Example: All items under a subsection
   - Extractable if: Items are logically grouped

4. **Individual Item** (Single bullet point + children)
   - Example: "Feature A: High priority" + sub-items
   - Extractable if: Item is self-contained

### Extraction Rules

```python
def identify_extraction_units(section: SectionNode) -> List[ExtractionUnit]:
    units = []
    
    # Check if entire section is extractable
    if section.extractable:
        units.append(ExtractionUnit(
            type="full_section",
            section_id=section.id,
            content_lines=(section.line_start, section.line_end)
        ))
    
    # Check subsections
    for child_id in section.children:
        child = find_section(child_id, sections)
        if child.extractable:
            units.append(ExtractionUnit(
                type="subsection",
                section_id=child.id,
                content_lines=(child.line_start, child.line_end)
            ))
    
    # Check item groups
    item_groups = group_related_items(section.items)
    for group in item_groups:
        if is_extractable_group(group):
            units.append(ExtractionUnit(
                type="item_group",
                item_ids=[item.id for item in group],
                content_lines=(group[0].line_start, group[-1].line_end)
            ))
    
    return units
```

## Review Interface

### Visual Representation

For review, the parser generates a visual representation:

```markdown
📄 Calendar/20250113.txt

┌─ # Work [sect-001] ✅ Extractable
│  └─ ## Project X Planning Meeting [subsect-001] ✅ Extractable
│     ├─ 📝 Context: "Discussed roadmap for Q2:"
│     ├─ • Feature A: High priority [item-001] ✅ Extractable
│     │  ├─ • Design mockups needed [item-001-1]
│     │  └─ • Engineering estimate: 2 weeks [item-001-2]
│     └─ • Feature B: Deferred [item-002] ✅ Extractable
│        └─ • Waiting on stakeholder feedback [item-002-1]
│
└─ # Personal [sect-002] ✅ Extractable
   └─ ## Todos [subsect-002] ✅ Extractable
      ├─ • [ ] Buy groceries [item-003] ✅ Extractable
      │  ├─ • Milk [item-003-1]
      │  └─ • Bread [item-003-2]
      └─ • [ ] Call dentist [item-004] ✅ Extractable
         └─ • Schedule cleaning [item-004-1]
```

### Extraction Preview

When reviewing, show what will be extracted:

```json
{
  "extraction_unit": {
    "type": "subsection",
    "id": "subsect-001",
    "heading": "## Project X Planning Meeting",
    "content_preview": "Discussed roadmap for Q2:\n- Feature A: High priority\n  - Design mockups needed\n  - Engineering estimate: 2 weeks\n- Feature B: Deferred\n  - Waiting on stakeholder feedback",
    "line_range": [8, 15],
    "target_bucket": "Notes/Projects/Work/ProjectX/meetings.txt",
    "dependencies": [],
    "will_split_from": "sect-001"  // Parent section
  }
}
```

## Implementation Details

### Technology Stack

- **Language**: Python (for parsing logic)
- **Markdown Parser**: `markdown` library or custom parser
- **YAML Parser**: `pyyaml` for frontmatter
- **Output Format**: JSON for structured data

### Performance Considerations

- **Caching**: Cache parsed structures (hash-based)
- **Incremental Parsing**: Only re-parse changed sections
- **Lazy Evaluation**: Don't parse full document if only checking structure

### Error Handling

- **Malformed Markdown**: Graceful degradation, report issues
- **Unclosed Sections**: Infer boundaries from context
- **Invalid Indentation**: Normalize and warn

## Testing Strategy

### Unit Tests

- Parse simple document with one section
- Parse document with nested sections
- Parse document with frontmatter
- Parse document with mixed content types
- Handle edge cases (empty sections, malformed markdown)

### Integration Tests

- Parse real daily notes from repository
- Verify extraction units are correctly identified
- Verify dependencies are correctly detected
- Verify review interface shows correct structure

## Dependencies

- **Input**: Markdown document files
- **Output**: Used by Content Sectioner component
- **Configuration**: Extraction rules, dependency detection rules

## Future Enhancements

1. **Smart Grouping**: AI-assisted grouping of related items
2. **Context Preservation**: Better handling of shared context
3. **Cross-Reference Detection**: Detect references between sections
4. **Template Recognition**: Identify common patterns (meeting notes, todos, etc.)

## Related Components

This component is used by:
- **Content Sectioner**: Uses parsed structure to identify extractable sections
- **Content Analyzer**: Uses structure to understand content context
- **Plan Maker**: Uses structure to generate extraction plans

## Open Questions

1. How to handle very long sections? (Split further?)
2. How to handle sections that reference each other? (Extract together?)
3. How to handle context that's shared across multiple items? (Include in extraction?)
