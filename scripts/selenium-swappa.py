#!/usr/bin/env python3

import os 

import requests

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait

# Fill in with your own Prowl API key here and remove 123456789
with open(os.path.expanduser("~/.secrets/prowl-api-key"), "r") as f:
	APIKEY = f.read().strip()

# https://www.browserstack.com/guide/wait-commands-in-selenium-webdriver
# https://www.w3schools.com/cssref/css_selectors.php
# https://selenium-python.readthedocs.io/locating-elements.html
# https://www.selenium.dev/selenium/docs/api/py/webdriver_support/selenium.webdriver.support.expected_conditions.html#selenium.webdriver.support.expected_conditions.text_to_be_present_in_element
# https://selenium-python.readthedocs.io/waits.html
# https://www.selenium.dev/blog/2023/headless-is-going-away/
# https://stackoverflow.com/questions/45631715/downloading-with-chrome-headless-and-selenium/73840130#73840130

options = Options()
# To hide browser ...
# options.add_argument("--headless=new")
options.page_load_strategy = 'normal'
driver = webdriver.Chrome(options=options)

def get_price_dict_for_swappa_options_page(driver, page):
	driver.get(page)
	driver.find_element(By.LINK_TEXT, "More Carriers and Options").click()
	WebDriverWait(driver, 100).until(EC.visibility_of_element_located((By.CSS_SELECTOR, "#slide_product_subs .slide_menu_item .item_label")))
	return (
		dict(
			zip(
				[
					x.text
					for x in driver.find_elements(By.CSS_SELECTOR, "#slide_product_subs .slide_menu_item .item_label")
				],
				[
					int(x.text.replace("+", "").replace("$", "")) if x.text.strip() else None
					for x in driver.find_elements(By.CSS_SELECTOR, "#slide_product_subs .slide_menu_item .float-end")
				]
			)
		)
	)

pages = {
	"iPadPro12Gen6": "https://swappa.com/buy/apple-ipad-pro-129-6th-gen-2022",
	"iPadPro11Gen4": "https://swappa.com/buy/apple-ipad-pro-11-4th-gen-2022"
}

prices = {
	"iPadPro12Gen6": 600,
	"iPadPro11Gen4": 450
}

def notify_iphone(app, event, desc):
	url = "https://api.prowlapp.com/publicapi/add"
	form_data = {
	  "apikey": APIKEY,
	  "application": f"{app}",
	  "event": f"  {event}",
	  "description": f"{desc}"
	}
	headers = { "Accept": "content/json" }
	server = requests.post(url, data=form_data, headers=headers)
	output = server.text
	print('The response from the server is: \n', output)

for page, url in pages.items():
	price_dict = get_price_dict_for_swappa_options_page(driver, url)
	current_wifi_price = price_dict.get("Wi-Fi")
	max_budget_for_wifi = prices[page]
	print(page, price_dict, current_wifi_price)
	if current_wifi_price <= max_budget_for_wifi:
		notify_iphone("Swappa", page, f"Wi-Fi price is under ${max_budget_for_wifi}. Currently ${current_wifi_price}.")

driver.quit()
