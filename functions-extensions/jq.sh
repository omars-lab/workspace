
function json-to-mdtable() {
	jq -rc --arg pipe "|" 'def handle_row:( "|\(join($pipe))|" ); ( [.[0] | to_entries | map(.key) | handle_row ] + [.[0] | to_entries | map("-----") | handle_row ] + [ .[] | to_entries | map(.value) | handle_row ] ) | .[]'
}
