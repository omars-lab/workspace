#!/usr/bin/env python

import os 
import ipdb 

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.common.keys import Keys


with open(os.path.expanduser("~/.secrets/yahoo-password"), "r") as f:
	password = None
	for line in f.read().strip().split("\n"):
		print(line)
		try:
			key, value = line.split("=", 1)
			if key == "YAHOO":
				password = value
		except Exception as e:
			continue

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
# https://stackoverflow.com/questions/15058462/how-to-save-and-load-cookies-using-python-selenium-webdriver
options.add_argument("user-data-dir=selenium")
driver = webdriver.Chrome(options=options)

url = 'https://login.yahoo.com?.src=ym&.lang=en-US&.intl=us&.done=https%3A%2F%2Fmail.yahoo.com%2Fd'

# When cookies are enabled ... I login directly ... I should have a login script ... to set things up ... and another script ... to do cleanup 
driver.get(url)
wait = WebDriverWait(driver, 10)

emailelem = wait.until(EC.presence_of_element_located((By.ID,'login-username')))
emailelem.send_keys('omar_eid21@yahoo.com')
wait.until(EC.element_to_be_clickable((By.ID,'login-signin')))
emailelem.submit()

passwordelem = wait.until(EC.presence_of_element_located((By.ID,'login-passwd')))
passwordelem.send_keys(password)
passwordelem.send_keys(Keys.RETURN)

ipdb.set_trace()

driver.quit()

# <input class="phone-no " type="text" name="username" id="login-username" value="" autocomplete="username" autocapitalize="none" autocorrect="off" autofocus="true" placeholder=" ">