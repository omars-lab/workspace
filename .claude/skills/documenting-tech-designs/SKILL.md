---
name: documenting-tech-designs
description: Guidance on documeting the design of tech components.
---

# Design Documentation Skill

**Purpose**: Document the methodology for creating engineering design documents, starting with high-level designs and breaking into detailed component designs as needed.

**Use Case**: When designing complex systems, start with a comprehensive high-level design document, then identify components that need detailed specifications and create separate low-level design documents.

## Core Approach

### Principle: Progressive Design Decomposition

1. **Start High-Level**: Create a single comprehensive design document covering the entire system
2. **Identify Complexity**: During high-level design, identify components that are:
   - Complex enough to warrant detailed specification
   - Independent enough to be designed separately
   - Reusable across multiple systems
3. **Break Out Details**: Create separate detailed design documents for complex components
4. **Maintain References**: Link between high-level and detailed designs

## When to Create Separate Design Documents

### Criteria for Separate Detailed Design

Create a separate detailed design document when a component meets **one or more** of these criteria:

1. **High Complexity**
   - Component has intricate algorithms or logic
   - Requires detailed data structures and interfaces
   - Has multiple sub-components or phases
   - **Example**: Document parser with markdown parsing, hierarchy building, extractability analysis

2. **Independent Functionality**
   - Component can be understood and designed independently
   - Has clear input/output interfaces
   - Can be tested in isolation
   - **Example**: Document Splitter that takes markdown → returns structured JSON

3. **Reusability**
   - Component may be reused in other systems
   - Has general-purpose functionality
   - **Example**: Generic markdown parser, hash service

4. **Specialized Domain Knowledge**
   - Requires deep expertise in specific domain
   - Has domain-specific algorithms or patterns
   - **Example**: NLP content analyzer, graph relationship mapper

5. **Significant Implementation Risk**
   - Component is critical to system success
   - Has technical challenges or unknowns
   - Requires proof-of-concept or research
   - **Example**: AI/LLM integration component

### When to Keep in Main Design

Keep component design in the main document when:

- Component is straightforward (simple CRUD, basic transformations)
- Component is tightly coupled to system (can't be understood independently)
- Component is well-understood (standard patterns, existing libraries)
- Component is small (single function or simple class)

## Design Document Structure

### High-Level Design Document

**Target Audience**: Manager, stakeholders, other engineers reviewing the system

**Structure**:

1. **Executive Summary**
   - Problem statement
   - Solution overview
   - Key design decisions
   - Timeline and resources

2. **Requirements**
   - Critical requirements (must have)
   - Important requirements (should have)
   - Nice-to-have requirements (could have)
   - Format: Question/Answer pairs addressing stakeholder concerns

3. **System Architecture**
   - High-level component diagram
   - Data flow
   - Integration points
   - Technology choices

4. **Workflow/Process Flow**
   - Step-by-step process
   - Activity diagrams (Mermaid)
   - Decision points
   - Approval gates

5. **Component Overview**
   - List of components
   - Brief description of each
   - References to detailed designs (if any)
   - Complexity assessment

6. **Implementation Plan**
   - Phases/milestones
   - Dependencies
   - Risk mitigation
   - Success criteria

7. **Design Considerations**
   - Assumptions
   - Constraints
   - Trade-offs
   - Open questions

### Detailed Component Design Document

**Target Audience**: Engineers implementing the component

**Structure**:

1. **Overview**
   - Component purpose
   - Parent design reference
   - Problem statement

2. **Component Architecture**
   - Architecture diagram (Mermaid) showing:
     - Input/output layers
     - Processing layers
     - Analysis layers
     - Support components
   - Component inputs/outputs
   - Internal structure
   - Sub-components
   - Data flow

3. **Data Structures**
   - Interfaces
   - Models
   - Schemas
   - Type definitions

4. **Algorithms**
   - Processing steps
   - Pseudo-code or detailed logic
   - Edge cases
   - Performance considerations

5. **Activity Diagrams**
   - Main processing flow (Mermaid)
   - Sub-process flows (if complex)
   - Error handling paths
   - Decision points

6. **Context Diagram**
   - Component's place in system (Mermaid)
   - External systems
   - Consuming components
   - Support systems

7. **Sequence Diagrams**
   - Main interaction sequence (Mermaid)
   - Sub-process sequences (if complex)
   - Error scenarios
   - Cache interactions (if applicable)

8. **Implementation Details**
   - **Script/Code Location**: Exact file paths (e.g., `/path/to/scripts/component-name`)
   - **Technology Stack**: Languages, libraries, versions
   - **Dependencies**: External libraries, system requirements
   - **Command-Line Interface**: Full CLI specification with examples
   - **Configuration**: Config files, environment variables, defaults
   - **Error Handling**: Error codes, messages, graceful degradation
   - **Safety Requirements**: Read-only operations, validation checks, safety guarantees

9. **Testing Strategy**
   - **Test Location**: Exact test directory path (e.g., `/path/to/tests/component-name/`)
   - **Test Structure**: Test files, fixtures directory, expected outputs
   - **Sample Test Data**: Specifications for test fixtures with examples
   - **Git Hooks**: Pre-commit hook requirements and setup
   - **Test Categories**: 
     - Unit tests (parsing, logic, edge cases)
     - Integration tests (with real data)
     - Safety tests (read-only verification)
     - Performance tests (if applicable)
   - **Test Script**: Test runner implementation details

10. **Related Components**
    - Dependencies
    - Integration points
    - Usage examples
    - How other components use this component

## Design Process

### Step 1: Initial High-Level Design

Create comprehensive high-level design covering:
- System overview
- All major components
- Workflows and processes
- Integration points

**Do NOT** go into deep implementation details yet.

### Step 2: Component Complexity Assessment

For each component identified in high-level design, assess:

```markdown
**Component Name**: [Component]
- **Complexity**: High/Medium/Low
- **Independence**: Can be designed separately? Yes/No
- **Reusability**: Will be reused? Yes/No
- **Risk**: High/Medium/Low
- **Decision**: Separate design / Inline in main document
```

### Step 3: Create Detailed Designs

For components requiring separate designs:

1. Create new file: `docs/plans/[component-name]-design.md`
2. Reference from main design: "See detailed design: `[component-name]-design.md`"
3. Include in main design's "Component Design Documents" section
4. Maintain bidirectional links

### Step 4: Review and Refine

- Ensure high-level design remains readable (not too detailed)
- Ensure detailed designs are complete and implementable
- Verify all components are covered (either inline or separate)
- Check that references are clear and accurate

## Example: NotePlan Organization System

### High-Level Design
- **File**: `docs/plans/noteplan-organization.md`
- **Components Identified**:
  - Document Splitter (High complexity → Separate design)
  - Content Analyzer (Medium complexity → Inline)
  - Bucket Analyzer (Medium complexity → Inline)
  - Delta Processor (Medium complexity → Inline)

### Detailed Component Design
- **File**: `docs/plans/document-splitter-design.md`
- **Reason**: Complex markdown parsing, hierarchical structure building, extractability analysis
- **Reference**: Linked from main design's component list and workflow steps

### Result
- High-level design remains focused on system architecture and workflow
- Detailed design provides implementable specification for complex component
- Clear separation of concerns
- Easy to navigate and understand

## Best Practices

### 1. Start Broad, Then Narrow

- Begin with system-wide view
- Identify components during design
- Only break out what needs detail
- Don't over-engineer the structure

### 2. Maintain Clear References

- Always link from high-level to detailed designs
- Include "See detailed design: [file]" in component descriptions
- List all design documents in a "Component Design Documents" section
- Use consistent naming: `[component-name]-design.md`

### 3. Keep High-Level Design Readable

- Target: Manager/stakeholder can understand system without reading detailed designs
- Detailed designs: Engineers can implement without reading high-level (except for context)
- Avoid: High-level design becoming too detailed, losing focus

### 4. Document Decisions

- Explain WHY a component needs separate design
- Document complexity assessment
- Note trade-offs and alternatives considered

### 5. Use Visual Aids (Mermaid Diagrams)

**High-Level Design Should Include**:
- System architecture diagram (component relationships)
- Activity/workflow diagrams (process flows, decision points)
- Context diagram (system boundaries, external interactions)

**Detailed Component Design Should Include**:
- **Architecture Diagram**: Internal component structure, layers, sub-components
- **Activity Diagrams**: Processing flows, decision points, error handling
- **Context Diagram**: Component's place in system, interactions with other components
- **Sequence Diagrams**: Component interactions, data flow, timing

**Diagram Best Practices**:
- Use Mermaid syntax for version-controllable diagrams
- Color-code by component type or layer
- Include error paths and edge cases
- Show read-only vs read-write operations clearly
- Label all flows and decision points

### 6. Progressive Disclosure

- High-level: "Component X parses markdown and identifies sections"
- Detailed: Full algorithm, data structures, parsing logic

### 7. Consistency

- Use same structure across all design documents
- Consistent terminology
- Consistent diagram styles (Mermaid)
- Consistent formatting

## Design Document Template

### High-Level Design Template

```markdown
# [System Name] - Design Document

**Author**: [Team]  
**Date**: [Date]  
**Status**: [Design Proposal / Approved / In Progress]  
**Version**: [Version]

## Executive Summary
[Problem, solution, key decisions]

## Requirements
[Stakeholder questions and answers]

## System Architecture
[Component diagram, data flow]

## Component Design Documents
[List of components, which have detailed designs]

## Workflow
[Process flow, activity diagrams]

## Implementation Plan
[Phases, milestones, timeline]

## Design Considerations
[Assumptions, constraints, trade-offs]
```

### Detailed Component Design Template

```markdown
# [Component Name] Component - Detailed Design

**Author**: [Team]  
**Date**: [Date]  
**Status**: [Detailed Design - Component Specification]  
**Version**: [Version]  
**Parent Design**: [link to high-level design]

## Overview
[Component purpose, problem statement]
[Critical safety requirements if applicable - e.g., read-only operations]

## Component Architecture
[Architecture diagram in Mermaid showing internal structure]

## Activity Diagrams
[Activity/workflow diagrams in Mermaid showing processing flows]

## Context Diagram
[Context diagram in Mermaid showing component's place in system]

## Sequence Diagrams
[Sequence diagrams in Mermaid showing component interactions]

## Data Structures
[Interfaces, models, schemas, type definitions]

## Algorithms
[Processing steps, pseudo-code, detailed logic]

## Implementation Details
- **Script/Code Location**: Exact file paths
- **Technology Stack**: Languages, libraries, dependencies
- **Command-Line Interface**: If applicable, full CLI specification
- **Configuration**: Config files, environment variables
- **Error Handling**: Error codes, error messages, graceful degradation
- **Safety Requirements**: Read-only operations, validation checks

## Testing Strategy
- **Test Location**: Exact test directory path
- **Test Structure**: Test files, fixtures, expected outputs
- **Sample Test Data**: Specifications for test fixtures
- **Git Hooks**: Pre-commit testing requirements
- **Test Categories**: Unit tests, integration tests, edge cases
- **Read-Only Verification**: Tests to verify no source file modification

## Related Components
[Dependencies, integration points, usage examples]

## Implementation Checklist
[Detailed checklist of implementation tasks]
```

## Checklist

### High-Level Design Checklist

- [ ] High-level design covers entire system
- [ ] All components identified and described
- [ ] Complex components assessed for separate design
- [ ] References maintained between designs
- [ ] High-level design remains readable (not too detailed)
- [ ] Requirements addressed (stakeholder concerns)
- [ ] Implementation plan is clear
- [ ] Design decisions documented
- [ ] Open questions identified
- [ ] **Visual Diagrams**:
  - [ ] System architecture diagram (Mermaid)
  - [ ] Activity/workflow diagrams (Mermaid)
  - [ ] Context diagram (Mermaid)

### Detailed Component Design Checklist

- [ ] Detailed designs are implementable (sufficient detail)
- [ ] Exact file paths and locations specified
- [ ] Command-line interface fully specified (if applicable)
- [ ] Safety requirements clearly stated (read-only, validation)
- [ ] **Visual Diagrams**:
  - [ ] Architecture diagram (internal component structure)
  - [ ] Activity diagrams (processing flows)
  - [ ] Context diagram (component's place in system)
  - [ ] Sequence diagrams (component interactions)
- [ ] **Testing Requirements**:
  - [ ] Test directory structure specified
  - [ ] Sample test fixtures described
  - [ ] Git hook requirements specified
  - [ ] Read-only verification tests included
- [ ] **Implementation Details**:
  - [ ] Technology stack specified
  - [ ] Dependencies listed
  - [ ] Error handling documented
  - [ ] Configuration options defined
- [ ] Implementation checklist included

## Common Patterns

### Pattern 1: Parser/Processor Components

**Often Need Separate Design**:
- Markdown/XML/JSON parsers
- Content processors
- Data transformers
- Format converters

**Reason**: Complex parsing logic, detailed data structures, edge cases

**Design Requirements**:
- Architecture diagram showing parsing layers
- Activity diagrams for parsing flow
- Sequence diagrams for parser interactions
- Detailed data structures for parsed output
- Comprehensive test fixtures (various input formats)
- Read-only operation emphasis (if processing source files)

### Pattern 2: AI/ML Components

**Often Need Separate Design**:
- LLM integration
- Content analyzers
- Classification systems
- Recommendation engines

**Reason**: Complex integration, prompt engineering, model selection, performance considerations

### Pattern 3: Integration Components

**Often Need Separate Design**:
- API clients
- Database connectors
- External service integrations
- Protocol handlers

**Reason**: Complex protocols, error handling, retry logic, authentication

### Pattern 4: Core Business Logic

**Often Inline in Main Design**:
- Simple CRUD operations
- Basic transformations
- Standard workflows
- Well-understood patterns

**Reason**: Straightforward, tightly coupled, standard patterns

## Anti-Patterns to Avoid

1. **Over-Decomposition**: Creating separate designs for simple components
2. **Under-Decomposition**: Keeping complex components inline, making main design too detailed
3. **Orphaned Designs**: Detailed designs not referenced from main design
4. **Circular Dependencies**: Designs referencing each other in confusing ways
5. **Inconsistent Structure**: Different structure across design documents
6. **Missing Context**: Detailed designs that can't be understood without reading high-level

## Tools and Formats

### Recommended Tools

- **Markdown**: For all design documents (readable, version-controllable)
- **Mermaid**: For diagrams (flowcharts, sequence diagrams, component diagrams, architecture diagrams)
  - Use consistent color coding
  - Include error paths
  - Show read-only vs read-write operations
- **JSON/YAML**: For data structure examples, configuration examples
- **Code Blocks**: For algorithms, pseudo-code, examples, CLI usage

### Diagram Types in Mermaid

**For High-Level Designs**:
- `graph TB` or `graph LR`: System architecture, component relationships
- `flowchart TD`: Activity/workflow diagrams
- `graph TB`: Context diagrams (system boundaries)

**For Detailed Component Designs**:
- `graph TB`: Architecture diagrams (internal component structure)
- `flowchart TD`: Activity diagrams (processing flows, decision points)
- `graph TB`: Context diagrams (component's place in system)
- `sequenceDiagram`: Sequence diagrams (component interactions, timing)

**Diagram Best Practices**:
- Use descriptive node labels
- Color-code by component type or layer
- Include error/exception paths
- Show validation and safety checks
- Use consistent styling across all diagrams

### File Organization

```
docs/plans/
  ├── [system-name]-design.md          # High-level design
  ├── [component-1]-design.md          # Detailed component design
  ├── [component-2]-design.md          # Detailed component design
  └── ...
```

## Success Criteria

A well-designed system has:

1. **Clear High-Level Design**: Manager/stakeholder can understand system architecture and workflow
2. **Detailed Component Designs**: Engineers can implement components from detailed designs
3. **Appropriate Granularity**: Right level of detail in right places
4. **Clear References**: Easy to navigate between high-level and detailed designs
5. **Complete Coverage**: All components designed (either inline or separate)
6. **Implementable**: Designs provide sufficient detail for implementation
7. **Visual Clarity**: Diagrams make architecture and flows immediately understandable
8. **Testable**: Test requirements and fixtures are clearly specified
9. **Safe**: Safety requirements (read-only, validation) are explicitly documented
10. **Executable**: Exact file paths, CLI specs, and setup instructions enable immediate implementation

## Related Skills

- **System Architecture**: Understanding how to structure systems
- **Technical Writing**: Communicating design clearly
- **Requirements Analysis**: Identifying what needs to be designed
- **Component Design**: Designing individual components
- **Diagramming**: Creating visual representations

## Key Learnings from Document Splitter Design

### What Made the Design Effective

1. **Comprehensive Diagrams**: Including architecture, activity, context, and sequence diagrams provided complete visual specification
2. **Exact Implementation Details**: Specifying exact file paths (`/Users/omareid/Workspace/git/workspace/scripts/noteplan-parse`) enabled immediate implementation
3. **Safety Emphasis**: Explicitly documenting read-only operations prevented accidental data modification
4. **Test Specifications**: Detailed test structure, fixtures, and git hooks ensured quality from the start
5. **CLI Specification**: Full command-line interface specification made the component immediately usable
6. **Implementation Checklist**: Step-by-step checklist ensured nothing was missed

### Patterns to Replicate

- **Multiple Diagram Types**: Architecture + Activity + Context + Sequence = Complete picture
- **Exact Paths**: Don't use placeholders, specify exact file locations
- **Safety First**: Document read-only operations, validation checks, error handling
- **Test-Driven**: Specify test structure, fixtures, and automation (git hooks) upfront
- **CLI-First**: If it's a script, fully specify the CLI interface
- **Progressive Detail**: High-level overview → Detailed sections → Implementation checklist

## References

- Example High-Level Design: `docs/plans/noteplan-organization.md`
- Example Detailed Component Design: `docs/plans/document-splitter-design.md`
  - Shows comprehensive Mermaid diagrams (architecture, activity, context, sequence)
  - Shows exact implementation paths and CLI specification
  - Shows testing requirements with git hooks
  - Shows read-only operation emphasis
