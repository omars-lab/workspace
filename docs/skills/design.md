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

2. **Architecture**
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

5. **Implementation Details**
   - Technology stack
   - Dependencies
   - Configuration
   - Error handling

6. **Testing Strategy**
   - Unit tests
   - Integration tests
   - Edge cases
   - Performance tests

7. **Related Components**
   - Dependencies
   - Integration points
   - Usage examples

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

### 5. Use Visual Aids

- Component diagrams in high-level design
- Detailed architecture diagrams in component designs
- Activity flow diagrams for processes
- Data flow diagrams for complex interactions

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

## Architecture
[Inputs/outputs, internal structure]

## Data Structures
[Interfaces, models, schemas]

## Algorithms
[Processing steps, pseudo-code]

## Implementation Details
[Tech stack, dependencies, configuration]

## Testing Strategy
[Unit tests, integration tests]

## Related Components
[Dependencies, integration points]
```

## Checklist

When creating design documents, ensure:

- [ ] High-level design covers entire system
- [ ] All components identified and described
- [ ] Complex components assessed for separate design
- [ ] Detailed designs created for complex components
- [ ] References maintained between designs
- [ ] High-level design remains readable (not too detailed)
- [ ] Detailed designs are implementable (sufficient detail)
- [ ] Visual diagrams included where helpful
- [ ] Requirements addressed (stakeholder concerns)
- [ ] Implementation plan is clear
- [ ] Design decisions documented
- [ ] Open questions identified

## Common Patterns

### Pattern 1: Parser/Processor Components

**Often Need Separate Design**:
- Markdown/XML/JSON parsers
- Content processors
- Data transformers
- Format converters

**Reason**: Complex parsing logic, detailed data structures, edge cases

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
- **Mermaid**: For diagrams (flowcharts, sequence diagrams, component diagrams)
- **JSON/YAML**: For data structure examples
- **Code Blocks**: For algorithms, pseudo-code, examples

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

## Related Skills

- **System Architecture**: Understanding how to structure systems
- **Technical Writing**: Communicating design clearly
- **Requirements Analysis**: Identifying what needs to be designed
- **Component Design**: Designing individual components
- **Diagramming**: Creating visual representations

## References

- Example High-Level Design: `docs/plans/noteplan-organization.md`
- Example Detailed Component Design: `docs/plans/document-splitter-design.md`
