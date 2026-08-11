# Sample Outputs

This directory contains sample JSON outputs from various scripts for documentation and reference purposes.

## Structure

Samples are organized by script name, matching the test fixtures structure:

```
tests/samples/
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

**Files**: One JSON sample per test fixture in `tests/fixtures/noteplan-parse/`

**Structure**: Matches test fixtures structure - samples organized by script name

**Mapping** (fixture → sample):
- `tests/fixtures/noteplan-parse/simple-daily-note.txt` → `tests/samples/noteplan-parse/simple-daily-note.json`
- `tests/fixtures/noteplan-parse/with-frontmatter.txt` → `tests/samples/noteplan-parse/with-frontmatter.json`
- `tests/fixtures/noteplan-parse/mixed-content.txt` → `tests/samples/noteplan-parse/mixed-content.json`
- `tests/fixtures/noteplan-parse/task-items.txt` → `tests/samples/noteplan-parse/task-items.json`
- `tests/fixtures/noteplan-parse/nested-sections.txt` → `tests/samples/noteplan-parse/nested-sections.json`
- etc.

**Naming Convention**: Sample file names match fixture names exactly (without `.txt` extension)

## Generating Samples

### noteplan-parse Samples

```bash
SAMPLES_DIR="tests/samples/noteplan-parse"
mkdir -p "${SAMPLES_DIR}"

for fixture in tests/fixtures/noteplan-parse/*.txt; do
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

- Test Fixtures: `tests/fixtures/noteplan-parse/`
