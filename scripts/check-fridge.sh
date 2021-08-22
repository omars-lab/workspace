#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

( \
	${DIR}/html-css-selector.py 'https://www.kitchenaid.com/major-appliances/refrigeration/refrigerators/french-door-refrigerators/p.25.8-cu.-ft.-36-multi-door-freestanding-refrigerator-with-platinum-interior-design.krmf706ess.html' '.temporarily-out-of-stock' 2>/dev/null \
	| grep -v 'Temporarily out of stock' \
) && ${DIR}/notify-iphone.sh "KitchenAid Fridge Is Available" "1M Cron"
