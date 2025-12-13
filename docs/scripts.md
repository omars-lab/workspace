# Scripts Documentation

This document provides an overview of all scripts in the `scripts/` directory.

For scripts in other directories, see:
- [scripts-shared.md](cursor://file/Users/omareid/Workspace/git/workspace/docs/scripts-shared.md) - Shared utility scripts
- [scripts-role-management.md](cursor://file/Users/omareid/Workspace/git/workspace/docs/scripts-role-management.md) - Role management scripts
- [setup.md](cursor://file/Users/omareid/Workspace/git/workspace/docs/setup.md) - Setup and installation scripts
- [backup.md](cursor://file/Users/omareid/Workspace/git/workspace/docs/backup.md) - Backup and restore scripts
- [installers.md](cursor://file/Users/omareid/Workspace/git/workspace/docs/installers.md) - Installer scripts

---

## Scripts by Directory

### scripts/

#### Shell Scripts (.sh)

- [check-apis.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts/check-apis.sh)
  - Check API availability and send alerts via iMessage
- [check-disneyworld.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts/check-disneyworld.sh)
  - Check Disney World availability and send notifications
- [check-fridge.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts/check-fridge.sh)
  - Check fridge status and send alerts
- [create-initiative.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts/create-initiative.sh)
  - Create new initiative files in the blueprints directory
- [cron-1d-ly.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts/cron-1d-ly.sh)
  - Daily cron job execution script
- [cron-1h-ly.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts/cron-1h-ly.sh)
  - Hourly cron job execution script
- [cron-1m-ly.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts/cron-1m-ly.sh)
  - Monthly cron job execution script
- [cron-5m-ly.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts/cron-5m-ly.sh)
  - 5-minute interval cron job execution script
- [cron-common.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts/cron-common.sh)
  - Common utilities and functions for cron jobs (logging, serial number, etc.)
- [cron-generate-crontab.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts/cron-generate-crontab.sh)
  - Generate crontab configuration from script definitions
- [cron-player.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts/cron-player.sh)
  - Execute cron jobs manually for testing
- [download-videos.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts/download-videos.sh)
  - Download videos using youtube-dl with quality selection
- [functions.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts/functions.sh)
  - Shared shell functions library
- [hook-button-black.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts/hook-button-black.sh)
  - Hook script for black button press (plays click sound)
- [hook-button-cicle.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts/hook-button-cicle.sh)
  - Hook script for circle button press (plays click sound) - typo in filename
- [hook-button-circle.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts/hook-button-circle.sh)
  - Hook script for circle button press (plays click sound)
- [hook-button-cross.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts/hook-button-cross.sh)
  - Hook script for cross button press (plays click sound)
- [hook-button-minus.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts/hook-button-minus.sh)
  - Hook script for minus button press (plays click sound)
- [hook-button-plus.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts/hook-button-plus.sh)
  - Hook script for plus button press (plays click sound)
- [hook-button-square.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts/hook-button-square.sh)
  - Hook script for square button press (plays click sound)
- [hook-button-triangle.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts/hook-button-triangle.sh)
  - Hook script for triangle button press (plays click sound)
- [image-ocr.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts/image-ocr.sh)
  - Extract text from images using macOS Vision framework OCR
- [increment-and-get-counter.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts/increment-and-get-counter.sh)
  - Increment a named counter file and return the new value
- [login-script-installer.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts/login-script-installer.sh)
  - Install scripts to run at login
- [noteplan-date-appender.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts/noteplan-date-appender.sh)
  - Append date information to NotePlan files
- [noteplan-helpers.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts/noteplan-helpers.sh)
  - Helper functions for NotePlan integration
- [notify-iphone.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts/notify-iphone.sh)
  - Send push notifications to iPhone via Prowl API
- [ocr.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts/ocr.sh)
  - OCR screenshots using tesseract and save to text files
- [paste2-loader.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts/paste2-loader.sh)
  - Load paste2 script configuration
- [python-stderr-to-vscode.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts/python-stderr-to-vscode.sh)
  - Redirect Python stderr output to VSCode for debugging
- [quotes-export.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts/quotes-export.sh)
  - Export quotes with IDs and prepare for DynamoDB import
- [report-tasks.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts/report-tasks.sh)
  - Generate high-level report of tasks from NotePlan calendar
- [run-homeassistant.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts/run-homeassistant.sh)
  - Run Home Assistant instance
- [send-imessage.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts/send-imessage.sh)
  - Send iMessage to phone number via AppleScript
- [shortcuts-clean.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts/shortcuts-clean.sh)
  - Clean up macOS shortcuts
- [shortcuts-update.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts/shortcuts-update.sh)
  - Update macOS shortcuts configuration
- [start-homeassistant.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts/start-homeassistant.sh)
  - Start Home Assistant service
- [svg-to-png.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts/svg-to-png.sh)
  - Convert SVG files to PNG format
- [switch-users.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts/switch-users.sh)
  - Switch macOS user accounts
- [sync-secrets-locally.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts/sync-secrets-locally.sh)
  - Sync secrets from remote storage to local environment
- [validate-notes.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts/validate-notes.sh)
  - Validate markdown links in notes to ensure they point to existing files

#### Python Scripts (.py)

- [animate.py](cursor://file/Users/omareid/Workspace/git/workspace/scripts/animate.py)
  - Animation utilities and helpers
- [brackets-to-tree.py](cursor://file/Users/omareid/Workspace/git/workspace/scripts/brackets-to-tree.py)
  - Convert bracket notation to tree structure
- [colorize.py](cursor://file/Users/omareid/Workspace/git/workspace/scripts/colorize.py)
  - Add color formatting to terminal output
- [costco-item-checker.py](cursor://file/Users/omareid/Workspace/git/workspace/scripts/costco-item-checker.py)
  - Check Costco item availability via API
- [dateround.py](cursor://file/Users/omareid/Workspace/git/workspace/scripts/dateround.py)
  - Round dates to specific intervals
- [download-link-title.py](cursor://file/Users/omareid/Workspace/git/workspace/scripts/download-link-title.py)
  - Download and extract title from web page
- [hash.py](cursor://file/Users/omareid/Workspace/git/workspace/scripts/hash.py)
  - Generate hash values for input data
- [html-css-selector.py](cursor://file/Users/omareid/Workspace/git/workspace/scripts/html-css-selector.py)
  - Extract content from HTML using CSS selectors
- [iphone-link-enricher.py](cursor://file/Users/omareid/Workspace/git/workspace/scripts/iphone-link-enricher.py)
  - Enrich iPhone links with metadata
- [parse-md-links.py](cursor://file/Users/omareid/Workspace/git/workspace/scripts/parse-md-links.py)
  - Parse and extract markdown links from files
- [plantuml-url-decode.py](cursor://file/Users/omareid/Workspace/git/workspace/scripts/plantuml-url-decode.py)
  - Decode PlantUML diagram URLs
- [prepare-ndjson-for-dynamodb.py](cursor://file/Users/omareid/Workspace/git/workspace/scripts/prepare-ndjson-for-dynamodb.py)
  - Prepare NDJSON files for DynamoDB import
- [sample-notification.py](cursor://file/Users/omareid/Workspace/git/workspace/scripts/sample-notification.py)
  - Send sample notification for testing
- [selenium-swappa.py](cursor://file/Users/omareid/Workspace/git/workspace/scripts/selenium-swappa.py)
  - Web scraper for Swappa using Selenium
- [selenium-yahoo-emails.py](cursor://file/Users/omareid/Workspace/git/workspace/scripts/selenium-yahoo-emails.py)
  - Scrape Yahoo emails using Selenium
- [selenium-yahoo-inbox-analytics.py](cursor://file/Users/omareid/Workspace/git/workspace/scripts/selenium-yahoo-inbox-analytics.py)
  - Analyze Yahoo inbox using Selenium
- [selenium-yahoo-login.py](cursor://file/Users/omareid/Workspace/git/workspace/scripts/selenium-yahoo-login.py)
  - Automated Yahoo login using Selenium
- [shorten-url.py](cursor://file/Users/omareid/Workspace/git/workspace/scripts/shorten-url.py)
  - Shorten URLs by removing marketing query parameters and copying to clipboard

#### JavaScript Scripts (.js)

- [link-router.js](cursor://file/Users/omareid/Workspace/git/workspace/scripts/link-router.js)
  - Route and handle different types of links

#### Other Executables

- [bookmark](cursor://file/Users/omareid/Workspace/git/workspace/scripts/bookmark)
  - Manage bookmarks stored as JSON on Desktop
- [brew-python](cursor://file/Users/omareid/Workspace/git/workspace/scripts/brew-python)
  - Install Python via Homebrew
- [cat-script](cursor://file/Users/omareid/Workspace/git/workspace/scripts/cat-script)
  - Display script contents with syntax highlighting
- [chrome-alert-whole-foods-cart](cursor://file/Users/omareid/Workspace/git/workspace/scripts/chrome-alert-whole-foods-cart)
  - Alert when Whole Foods cart has items
- [chrome-close-tabs-with](cursor://file/Users/omareid/Workspace/git/workspace/scripts/chrome-close-tabs-with)
  - Close Chrome tabs matching a pattern
- [conda-create-env](cursor://file/Users/omareid/Workspace/git/workspace/scripts/conda-create-env)
  - Create new conda environment
- [conda-list-envs](cursor://file/Users/omareid/Workspace/git/workspace/scripts/conda-list-envs)
  - List all conda environments
- [costco-item-checker](cursor://file/Users/omareid/Workspace/git/workspace/scripts/costco-item-checker)
  - Check Costco item availability (binary wrapper)
- [generate-link](cursor://file/Users/omareid/Workspace/git/workspace/scripts/generate-link)
  - Generate VSCode file links from file paths
- [git-reconfigure-author](cursor://file/Users/omareid/Workspace/git/workspace/scripts/git-reconfigure-author)
  - Reconfigure git author information
- [git-rewrite-author](cursor://file/Users/omareid/Workspace/git/workspace/scripts/git-rewrite-author)
  - Rewrite git commit author history
- [google-doc-outline-extractor](cursor://file/Users/omareid/Workspace/git/workspace/scripts/google-doc-outline-extractor)
  - Extract outline structure from Google Docs
- [html-table-to-json](cursor://file/Users/omareid/Workspace/git/workspace/scripts/html-table-to-json)
  - Convert HTML tables to JSON format
- [instock-alerts](cursor://file/Users/omareid/Workspace/git/workspace/scripts/instock-alerts)
  - Monitor and alert on in-stock items
- [interspace-commas](cursor://file/Users/omareid/Workspace/git/workspace/scripts/interspace-commas)
  - Add spaces after commas in text
- [json-to-png](cursor://file/Users/omareid/Workspace/git/workspace/scripts/json-to-png)
  - Convert JSON to PNG image
- [map-link-in-clipboard](cursor://file/Users/omareid/Workspace/git/workspace/scripts/map-link-in-clipboard)
  - Convert clipboard link to map URL
- [md-to-html](cursor://file/Users/omareid/Workspace/git/workspace/scripts/md-to-html)
  - Convert markdown to HTML
- [mermaid-to-svg](cursor://file/Users/omareid/Workspace/git/workspace/scripts/mermaid-to-svg)
  - Convert Mermaid diagrams to SVG
- [noteplan-editor](cursor://file/Users/omareid/Workspace/git/workspace/scripts/noteplan-editor)
  - Open NotePlan editor
- [open-in-chrome](cursor://file/Users/omareid/Workspace/git/workspace/scripts/open-in-chrome)
  - Open URL in Chrome browser
- [png-to-svg](cursor://file/Users/omareid/Workspace/git/workspace/scripts/png-to-svg)
  - Convert PNG images to SVG
- [puml-to-html](cursor://file/Users/omareid/Workspace/git/workspace/scripts/puml-to-html)
  - Convert PlantUML diagrams to HTML
- [puml-to-svg](cursor://file/Users/omareid/Workspace/git/workspace/scripts/puml-to-svg)
  - Convert PlantUML diagrams to SVG
- [puml-to-url](cursor://file/Users/omareid/Workspace/git/workspace/scripts/puml-to-url)
  - Convert PlantUML diagrams to web URL
- [python-report-env](cursor://file/Users/omareid/Workspace/git/workspace/scripts/python-report-env)
  - Report Python environment information
- [python-to-json](cursor://file/Users/omareid/Workspace/git/workspace/scripts/python-to-json)
  - Convert Python code/data to JSON
- [un-ascii-quote](cursor://file/Users/omareid/Workspace/git/workspace/scripts/un-ascii-quote)
  - Convert ASCII quotes to proper quotation marks
- [xml-to-json](cursor://file/Users/omareid/Workspace/git/workspace/scripts/xml-to-json)
  - Convert XML to JSON format
- [yaml-to-json](cursor://file/Users/omareid/Workspace/git/workspace/scripts/yaml-to-json)
  - Convert YAML to JSON format

#### AppleScript Files (.scpt)

- [mindnode-to-png-doesnt-work.scpt](cursor://file/Users/omareid/Workspace/git/workspace/scripts/mindnode-to-png-doesnt-work.scpt)
  - Attempted MindNode to PNG conversion (non-functional)
- [mindnode-to-png.scpt](cursor://file/Users/omareid/Workspace/git/workspace/scripts/mindnode-to-png.scpt)
  - Convert MindNode diagrams to PNG images

#### JAR Files

- [plantuml.jar](cursor://file/Users/omareid/Workspace/git/workspace/scripts/plantuml.jar)
  - PlantUML Java executable for generating diagrams

#### JQ Files

- [check-disneyworld.jq](cursor://file/Users/omareid/Workspace/git/workspace/scripts/check-disneyworld.jq)
  - JQ filter for processing Disney World availability data
- [html-table-to-json.jq](cursor://file/Users/omareid/Workspace/git/workspace/scripts/html-table-to-json.jq)
  - JQ filter for converting HTML tables to JSON

### scripts-shared/

- [color](cursor://file/Users/omareid/Workspace/git/workspace/scripts-shared/color)
- [date-deltas](cursor://file/Users/omareid/Workspace/git/workspace/scripts-shared/date-deltas)
- [find-links](cursor://file/Users/omareid/Workspace/git/workspace/scripts-shared/find-links)
- [firefox-tabs](cursor://file/Users/omareid/Workspace/git/workspace/scripts-shared/firefox-tabs)
- [html-decode](cursor://file/Users/omareid/Workspace/git/workspace/scripts-shared/html-decode)
- [html-encode](cursor://file/Users/omareid/Workspace/git/workspace/scripts-shared/html-encode)
- [interleave](cursor://file/Users/omareid/Workspace/git/workspace/scripts-shared/interleave)
- [lib.jq](cursor://file/Users/omareid/Workspace/git/workspace/scripts-shared/lib.jq)
- [list-links](cursor://file/Users/omareid/Workspace/git/workspace/scripts-shared/list-links)
- [noteplan](cursor://file/Users/omareid/Workspace/git/workspace/scripts-shared/noteplan)
- [parse-case](cursor://file/Users/omareid/Workspace/git/workspace/scripts-shared/parse-case)
- [print-link](cursor://file/Users/omareid/Workspace/git/workspace/scripts-shared/print-link)
- [print-vscode-link](cursor://file/Users/omareid/Workspace/git/workspace/scripts-shared/print-vscode-link)
- [resolve](cursor://file/Users/omareid/Workspace/git/workspace/scripts-shared/resolve)
- [search](cursor://file/Users/omareid/Workspace/git/workspace/scripts-shared/search)
- [sed-dates](cursor://file/Users/omareid/Workspace/git/workspace/scripts-shared/sed-dates)
- [sed-dates-reducer](cursor://file/Users/omareid/Workspace/git/workspace/scripts-shared/sed-dates-reducer)
- [sed-dates.test](cursor://file/Users/omareid/Workspace/git/workspace/scripts-shared/sed-dates.test)
- [validate-links](cursor://file/Users/omareid/Workspace/git/workspace/scripts-shared/validate-links)
- [vscode-link](cursor://file/Users/omareid/Workspace/git/workspace/scripts-shared/vscode-link)

### scripts-role-management/

- [activity-history.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts-role-management/activity-history.sh)
- [fix-permissions.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts-role-management/fix-permissions.sh)
- [managing-links.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts-role-management/managing-links.sh)
- [role-metrics.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts-role-management/role-metrics.sh)
- [role-refactoring.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts-role-management/role-refactoring.sh)
- [Generate Learning Catalog/link.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts-role-management/Generate%20Learning%20Catalog/link.sh)
- [Generate Learning Catalog/refresh-links.sh](cursor://file/Users/omareid/Workspace/git/workspace/scripts-role-management/Generate%20Learning%20Catalog/refresh-links.sh)

### setup/

- [setup-all.sh](cursor://file/Users/omareid/Workspace/git/workspace/setup/setup-all.sh)
- [setup-apps.sh](cursor://file/Users/omareid/Workspace/git/workspace/setup/setup-apps.sh)
- [setup-binaries.sh](cursor://file/Users/omareid/Workspace/git/workspace/setup/setup-binaries.sh)
- [setup-brew.sh](cursor://file/Users/omareid/Workspace/git/workspace/setup/setup-brew.sh)
- [setup-cron.sh](cursor://file/Users/omareid/Workspace/git/workspace/setup/setup-cron.sh)
- [setup-git.sh](cursor://file/Users/omareid/Workspace/git/workspace/setup/setup-git.sh)
- [setup-link.sh](cursor://file/Users/omareid/Workspace/git/workspace/setup/setup-link.sh)
- [setup-python.sh](cursor://file/Users/omareid/Workspace/git/workspace/setup/setup-python.sh)
- [setup-zsh.sh](cursor://file/Users/omareid/Workspace/git/workspace/setup/setup-zsh.sh)

### backup/

- [backup-laptop.sh](cursor://file/Users/omareid/Workspace/git/workspace/backup/backup-laptop.sh)
- [icloud-sync](cursor://file/Users/omareid/Workspace/git/workspace/backup/icloud-sync)
- [reload-laptop-one-time.sh](cursor://file/Users/omareid/Workspace/git/workspace/backup/reload-laptop-one-time.sh)
- [reload-laptop.sh](cursor://file/Users/omareid/Workspace/git/workspace/backup/reload-laptop.sh)

### installers/

- [brew-debugger.sh](cursor://file/Users/omareid/Workspace/git/workspace/installers/brew-debugger.sh)
- [sharedworkspace-installer.sh](cursor://file/Users/omareid/Workspace/git/workspace/installers/sharedworkspace-installer.sh)

---

## Usage Examples

For detailed usage examples of each script, see [Makefile-scripts](cursor://file/Users/omareid/Workspace/git/workspace/docs/Makefile-scripts) in the docs directory.

You can run examples using:
```bash
make -f docs/Makefile-scripts <script-name>
```

For example:
```bash
make -f docs/Makefile-scripts image-ocr
make -f docs/Makefile-scripts check-apis
```
