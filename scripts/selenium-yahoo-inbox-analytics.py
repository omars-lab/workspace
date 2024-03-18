#!/usr/bin/env python
import traceback
import os 
import ipdb 
import urllib.parse
import time
import json
import arrow

from bs4 import BeautifulSoup

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.action_chains import ActionChains

from collections import namedtuple

# - [ ] Todo ... add python logging support, turn it into cron, and add more emails!

EmptyElement = namedtuple('EmptyElement', ['attrs', 'text'])

def optionally_select(bs4_selection):
	if bs4_selection:
		return bs4_selection[0]
	return EmptyElement({}, "")


def convert_yahoo_time(t):
	try: 
		if "AM" in t:
			[h, m] = t.replace(" AM", "").split(":")
			a = arrow.utcnow().to('US/Central').replace(hour=int(h), minute=int(m)).floor("minute")
		elif "PM" in t:
			[h, m] = t.replace(" PM", "").split(":")
			a = arrow.utcnow().to('US/Central').replace(hour=int(h)+12, minute=int(m)).floor("minute")
		else:
			try:
				a = arrow.get(t)
			except Exception as e:
				try:
					a = arrow.get(f"{t} {arrow.get().year}", 'MMM D YYYY')
				except Exception as e:
						a = arrow.get(t, 'MM/DD/YYYY')
	except Exception as e:
		print(f"Failed to parse [{t}] into date")
		a = t
	return str(a)


def parse_email(message_element):
	# https://stackoverflow.com/questions/14049983/selenium-webdriver-finding-an-element-in-a-sub-element
	# https://stackoverflow.com/questions/14496860/how-to-beautiful-soup-bs4-match-just-one-and-only-one-css-class
	# print(message_element, dir(message_element), dict(message_element))
	element_html = message_element.get_attribute("innerHTML")
	if element_html.strip() == "":
		return {}
	element_soup = BeautifulSoup(element_html, 'html.parser')
	# email_elem = optionally_select(element_soup.select('a[data-test-id="message-list-item"]'))
	email_address_elem = optionally_select(element_soup.select('a[data-test-id="message-list-item"] span[data-test-id="senders_list"]'))
	sender_name_elem = optionally_select(element_soup.select('a[data-test-id="message-list-item"] strong[data-test-id="senders-bold"]'))
	subject_elem = optionally_select(element_soup.select('a[data-test-id="message-list-item"] span[data-test-id="message-subject"]'))
	read_button_elem = optionally_select(element_soup.select('a[data-test-id="message-list-item"] button[data-test-id="icon-btn-read"]'))
	time_elem = optionally_select(element_soup.select('a[data-test-id="message-list-item"] time'))
	# print(email_elem, email_address_elem, sender_name_elem, subject_elem, read_button_elem, time_elem)
	# {
		# "from_email_address": message_element.find_element(By.XPATH, ".//*[@data-test-id='senders_list']").get_attribute("title"),
		# "from": message_element.find_element(By.XPATH, ".//*[@data-test-id='senders-bold']").text,
		# "subject": message_element.find_element(By.XPATH, ".//*[@data-test-id='message-subject']").text,
		# "is_read?": not message_element.find_element(By.XPATH, ".//*[@data-test-id='icon-btn-read']").get_attribute("title") == "Mark as read",
		# "time": message_element.find_element(By.XPATH, ".//time").text,
	# }
	resp = {
		"from_email_address": email_address_elem.attrs.get("title") if email_address_elem else None,
		"from": sender_name_elem.text if sender_name_elem else None,
		"subject": subject_elem.text if subject_elem else None,
		"is_read?": (not read_button_elem.attrs.get("title") == "Mark as read") if read_button_elem else None,
		"time": convert_yahoo_time(time_elem.text) if (time_elem and time_elem.text) else None,
	}
	return resp
	


def get_inbox_analytics(driver, url, file_to_dump_email):
	driver.get(url)
	wait = WebDriverWait(driver, 2)
	long_wait = WebDriverWait(driver, 120)

	file1 = open(file_to_dump_email, "w")
	file1.close()

	try:
		# https://stackoverflow.com/questions/59130200/selenium-wait-until-element-is-present-visible-and-interactable
		# https://stackoverflow.com/questions/20759348/how-to-move-cursor-position-using-webdriver

		# main_mail_container = wait.until(EC.visibility_of_element_located((By.ID, "mail-app-component-container")))
		main_mail_container = wait.until(EC.visibility_of_element_located((By.XPATH, "//*[@data-test-id = 'virtual-list-container']")))
		# ipdb.set_trace()
		for p in [0]*100:
			time.sleep(4)
			messages = driver.find_elements(By.XPATH, f"//*[@data-test-id = 'virtual-list-container']//li")
			print(len(messages))
			email_chunk = [(parse_email(x), x) for x in messages]
			# print(parse_email(messages[-1]))
			file1 = open(file_to_dump_email, "a")  # append mode
			file1.writelines([f"{json.dumps(px)}\n" for (px, x) in email_chunk if px.get('from_email_address')])
			file1.close()
			for x in [x for (px, x) in email_chunk if not px.get('from_email_address')]:
				print("failed to parse email for: ", x, x.get_attribute("innerHTML"))
			driver.execute_script("arguments[0].scrollIntoView(true);", messages[-1]);
		# empty_results = wait.until(EC.visibility_of_element_located((By.XPATH, "//*[@data-test-id = 'senders_list']")))
		# print(empty_results.text)
		return False
	except Exception as e:
		print(e)
		print("Results not empty, continuing")

	# ipdb.set_trace()
	return True


options = Options()
# To hide browser ...
# options.add_argument("--headless=new")
options.page_load_strategy = 'normal'
# https://stackoverflow.com/questions/15058462/how-to-save-and-load-cookies-using-python-selenium-webdriver
options.add_argument("user-data-dir=selenium")
driver = webdriver.Chrome(options=options)

url = "https://mail.yahoo.com/d/folders/1"
get_inbox_analytics(driver, url, "inbox.jsonld")
driver.quit()


# To analyze emails after this ... `jq -r .from_email_address inbox.json-nd | sort | uniq -c | sort`