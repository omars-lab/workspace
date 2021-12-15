#!/bin/bash 

DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PATH="${DIR}:/usr/bin/:/usr/local/bin/:${PATH}"

function alert() {
  send-imessage.sh 5715356269 "${1}"
  send-imessage.sh 9722070770 "${1}"
}

function check_nawals_treadmill() {
    ( \
      curl -s 'https://api.costco.com/ebusiness/inventory/v1/inventorylevels/availability/1507350?destinationState=VA&destinationPostalCode=20170&destinationCountryCode=US&quantity=1&orderItemId=0&tvonly=n&shippingCode=LTW' \
        -H 'Connection: keep-alive' \
        -H 'Referer: https://www.costco.com/' \
        -H 'client-identifier: 481b1aec-aa3b-454b-b81b-48187e28f205' \
        -H 'Accept-Language: en-US,en;q=0.9,id;q=0.8' \
        -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36' \
        -H 'Accept: */*' \
        -H 'Origin: https://www.costco.com' \
        -H 'DNT: 1' \
        -H 'costco.env: ECOM' \
        -H 'sec-ch-ua-mobile: ?0' \
        -H 'sec-ch-ua: "Google Chrome";v="95", "Chromium";v="95", ";Not A Brand";v="99"' \
        -H 'sec-ch-ua-platform: "macOS"' \
        -H 'Sec-Fetch-Site: same-site' \
        -H 'Sec-Fetch-Mode: cors' \
        -H 'Sec-Fetch-Dest: empty' \
        --compressed \
      | jq -e '.availableForSale' > /dev/null \
    ) && ( \
      alert "Treadmill may be in stock: https://www.costco.com/proform-trainer-12.0-treadmill-with-1-year-ifit-membership-included---assembly-included.product.100713168.html" 
    )
}

true
