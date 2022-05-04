edit:
	open -a "Script Editor" "../../../Glue.app"

autogenerate-habits:
	ls -1 /Users/omareid/Workspace/git/blueprints/habits/ \
		| xargs -I __ jq -n --arg habit __ \
			'{} | {key: ($$habit|gsub("habit-";"")|gsub(".md";"")), value: "vscode://file/Users/omareid/Workspace/git/blueprints/habits/\($$habit)"}' | jq -s from_entries > Scripts/glue.habits.json
