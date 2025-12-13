# OPENAI_API_KEY=$(lpass-get-note automation/chatgpt-apikey)

# lpass ls automation  | grep secrets.sh | egrep -o '\d+' | xargs -n 1 lpass show --notes
# lpass ls automation  | grep $(get_uniq_mac_id) | egrep -o '\d+' | xargs -n 1 lpass show --notes