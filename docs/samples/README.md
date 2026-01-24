# Sample Outputs

This directory contains sample JSON outputs from various scripts for documentation and reference purposes.

## Structure

Samples are organized by script name, matching the test fixtures structure:

```
docs/samples/
├── noteplan-parse/          # Samples from noteplan-parse script
│   ├── simple-daily-note.json
│   ├── nested-sections.json
│   └── ...
└── [other-script]/          # Samples from other scripts
    └── ...
```

## Purpose

These samples demonstrate:
- The structure of script outputs
- Expected JSON formats
- How different inputs are processed
- Reference outputs for testing

## noteplan-parse Samples

Located in `noteplan-parse/` directory.

**Files**: One JSON sample per test fixture in `tests/noteplan-parse/fixtures/`

**Structure**: Matches test fixtures structure - samples organized by script name

**Mapping** (fixture → sample):
- `tests/noteplan-parse/fixtures/simple-daily-note.txt` → `docs/samples/noteplan-parse/simple-daily-note.json`
- `tests/noteplan-parse/fixtures/with-frontmatter.txt` → `docs/samples/noteplan-parse/with-frontmatter.json`
- `tests/noteplan-parse/fixtures/mixed-content.txt` → `docs/samples/noteplan-parse/mixed-content.json`
- `tests/noteplan-parse/fixtures/task-items.txt` → `docs/samples/noteplan-parse/task-items.json`
- `tests/noteplan-parse/fixtures/nested-sections.txt` → `docs/samples/noteplan-parse/nested-sections.json`
- etc.

**Naming Convention**: Sample file names match fixture names exactly (without `.txt` extension)

## Generating Samples

### noteplan-parse Samples

```bash
SAMPLES_DIR="docs/samples/noteplan-parse"
mkdir -p "${SAMPLES_DIR}"

for fixture in tests/noteplan-parse/fixtures/*.txt; do
    fixture_name=$(basename "${fixture}" .txt)
    scripts/noteplan-parse "${fixture}" \
        --output "${SAMPLES_DIR}/${fixture_name}.json"
done
```

## Usage

These samples can be used for:
- Understanding script output formats
- Testing visualization components
- Documentation examples
- Integration testing
- Comparing expected vs actual outputs

## Maintenance

- Samples should be regenerated when script logic changes
- Samples serve as "golden" reference outputs
- Keep sample file names matching fixture names (without extension)
- Update samples when adding new test fixtures

## Related Documentation

- Document Splitter Design: `docs/plans/document-splitter-design.md`
- Test Fixtures: `tests/noteplan-parse/fixtures/`
