#!/usr/bin/env python
import traceback
import os 
import ipdb 
import urllib.parse

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.action_chains import ActionChains

# - [ ] Todo ... add python logging support, turn it into cron, and add more emails!

def email_set_to_url(emails, yahoo_src_folder="inbox"):
	emailsToUrl = [f"from:{email}" for email in emails]
	joint_emails = " OR ".join(emailsToUrl)
	email_keyword_query = urllib.parse.quote(f"({joint_emails}) in:{yahoo_src_folder}")
	url = f"https://mail.yahoo.com/d/search/keyword={email_keyword_query}"
	# url = 'https://mail.yahoo.com/d/search/keyword=from%253Acontact%2540veiled.com%2520in%253Ainbox'
	# https://mail.yahoo.com/d/search/keyword=(from%253Acontact%2540veiled.com%2520OR%2520from%253Areply%2540email-surprise.katespade.com)%2520in%253Ainbox?guccounter=1
	# https://mail.yahoo.com/d/search/keyword=%28from%3Acontact%40veiled.com%20OR%20from%3Areply%40email-surprise.katespade.com%29%20in%3Ainbox
	return url

def move_emails_from_url_to_folder(driver, yahoo_search_url, dst_yahoo_folder):
	# Assumptions ... we are already logged in / coookies are setup in the selenium session ...
	# When cookies are enabled ... I login directly ... I should have a login script ... to set things up ... and another script ... to do cleanup 
	
	driver.get(yahoo_search_url)
	wait = WebDriverWait(driver, 2)
	long_wait = WebDriverWait(driver, 120)

	try:
		# https://stackoverflow.com/questions/59130200/selenium-wait-until-element-is-present-visible-and-interactable
		empty_results = wait.until(EC.visibility_of_element_located((By.XPATH, "//*[contains(text(), 'Nothing to see here!')]")))
		print(empty_results.text)
		return False
	except Exception as e:
		print(e)
		print("Results not empty, continuing")

	# Add a skip if there are no messages ...

	# https://stackoverflow.com/questions/15930683/click-a-button-with-xpath-containing-partial-id-and-title-in-selenium-ide
	# https://www.selenium.dev/documentation/webdriver/elements/locators/
	# https://www.freeformatter.com/xpath-tester.html#before-output
	select25button = wait.until(EC.presence_of_element_located((By.XPATH, "//*[contains(@title, 'Check all messages, 0 messages checked')]")))
	select25button.click()

	# This is optional ... if there are less than 25, then the button does not pop up ...
	try:
		selectAllbutton = wait.until(EC.presence_of_element_located((By.PARTIAL_LINK_TEXT, "Select all ")))
		selectAllbutton.click()
	except Exception as e:
		print('Skipping excpeption', e)

	# See how many are selected ...
	# https://stackoverflow.com/questions/53527313/webdriverwait-on-finding-element-by-css-selector
	countSelected = wait.until(EC.presence_of_element_located((By.CSS_SELECTOR, "#announcedSelectionCount > span")))
	print(countSelected.text)

	# Kick off moving to the folder
	# https://www.selenium.dev/selenium/docs/api/py/webdriver/selenium.webdriver.common.action_chains.html
	# https://www.programcreek.com/python/example/97717/selenium.webdriver.common.keys.Keys.SHIFT
	# https://stackoverflow.com/questions/56691117/send-keys-shifttab-on-selenium-web-driver
	a = ActionChains(driver)
	a.key_down(Keys.SHIFT).send_keys('d').key_up(Keys.SHIFT)
	a.perform()

	## If there is only 1 entry, we can do double enter then 
	a2 = ActionChains(driver).send_keys(dst_yahoo_folder).send_keys(Keys.RETURN).send_keys(Keys.RETURN)
	a2.perform()

	# Wait for the confirmation that all were moved ...
	# https://stackoverflow.com/questions/3655549/xpath-containstext-some-string-doesnt-work-when-used-with-node-with-more
	# https://stackoverflow.com/questions/3655549/xpath-containstext-some-string-doesnt-work-when-used-with-node-with-more
	movingStatus = long_wait.until(EC.presence_of_element_located((By.XPATH, "//*[contains(text(), 'conversations moved to')]")))
	print(movingStatus.text)

	# ipdb.set_trace()
	return True

# Debugging ...
# https://www.urlencoder.io/python/
# https://www.analyticsmania.com/post/how-to-pause-javascript-and-inspect-an-element-that-quickly-disappears/#:~:text=On%20Windows%2C%20you%20can%20press,is%20called%20%E2%80%9CDisable%20JavaScript%E2%80%9D.
# https://stackoverflow.com/questions/17931571/freeze-screen-in-chrome-debugger-devtools-panel-for-popover-inspection

options = Options()
# To hide browser ...
# options.add_argument("--headless=new")
options.page_load_strategy = 'normal'
# https://stackoverflow.com/questions/15058462/how-to-save-and-load-cookies-using-python-selenium-webdriver
options.add_argument("user-data-dir=selenium")
driver = webdriver.Chrome(options=options)

folder_moving_rules = {
	"A8N-Confirmations": [
		["mcinfo@ups.com", "no.reply.alerts@chase.com", "bananarepublicfactory@bananarepublicfactory.narvar.com", "uspsinformeddelivery@email.informeddelivery.usps.com"],
		["receipts@zakat.org", "billingnoreply@amica.com", "servicing@e.synchronyfinancial.com", "donorcare@irusa.org", "noreply@fundraiseup.com", "walgreens@wpht.walgreens.com"],
		["info@emails.photo.walgreens.com", "invoice+statements@zakat.org", "orders@email.bananarepublicfactory.com", "noreply@roller.app", "chase@e.chase.com"],
		["billing_web@questdiagnostics.com", "orders@email.bananarepublicfactory.com", "pamco@pamcotx.com", "orders@email.bananarepublicfactory.com"]
	],
	"A8N-Shopping": [
		["contact@veiled.com", "reply@email-surprise.katespade.com", "email@info.burlington.com", "reply@mc.katespadeoutlet.com", "news@official.pandora.net"],
		["news@email.nunababy.com", "aldoshoes@mailing.aldoshoes.com", "katespadeoutlet@pr.katespadesurprise.emailpowerreviews.com", "markandgraham@e.markandgraham.com"],
		["store+8127643763@g.shopifyemail.com", "contact@niswafashion.com", "ups@emails.ups.com", "newsletter@tesmanian.com", "nordstromrack@bv.nordstromrack.com"],
		["rejuvenation@e.rejuvenation.com", "hello@ohsnap.com"]
	],
	"A8N-Travel": [
		["*.hiltongrandvacations.com", "*.disneydestinations.com", "alerts@alert.gaylordhotels.com", "austrian@smile.austrian.com"],
		["hgv@travel.hiltongrandvacations.com", "disneyonbroadway@mail.disneyonbroadway.com", "noreply@email.wyndhamvo.com", "newsletter@your.lufthansa-group.com"]
	],
	"A8N-Food": [
		[
			"email@a.grubhub.com",
			"eurasiasushiaustin@spillover.com",
			"messages+d779m08v2sffw@squaremktg.com",
			"noreply@emails.baskinrobbins.com",
			"reply@emailinfo.buffalowildwings.com",
			"noreply@npower.naturalgrocers.com", 
			"noreply@postmates.com", 
			"no-reply+e8034925@toast-restaurants.com", 
			"info@honolulucookie.com", 
			"no-reply@mktus.venchi.com",
			"hello@einsteinbros.com",
			"info@menchies.com"
		],
		["ilovehotsauce@heatonist.com", "marketing.beardpapas.com@idl20w.sqspmail.com", "marketing@beardpapas.com", "*incentivio.com"]
	],
	"A8N-Books": [
		["contact@mailer.humblebundle.com"]
	],
	"A8N-Entertainment": [
		["disneyplus@mail.disneyplus.com", "newsletters@email.fxnetworks.info", "marvel@mail.marvel.com", "gamestop@emails.gamestop.com", "ng@about.nationalgeographic.com", "newsletters@email.watchabc.com"],
		["nintendo-noreply@nintendo.net", "disneyonice@email.feld-inc.com", "newsletter@email.ticketmaster.com", "max@stream.max.com", "disneymovies@em.disneymovies.com", "hi@camp.com"],
		["hello@thevirts.com", "waltdisneypictures@em.waltdisneypictures.com", "info@members.netflix.com", "events@hebcenter.com"],
		["topgolf@email.topgolf.com", "web.newsletter@e.sesame.org", "info@members.netflix.com"]
	],
	"A8N-Education": [
		["hello@ideou.com", "aimee@khanacademy.org"]
	],
	"A8N-Islamic": [
		["no-reply@tarteel.ai", "info@noorart.com", "store+3237019737@m.shopifyemail.com", "info@ewsouk.com", "info@crescentstarcreations.com", "info@peter-gould.com"],
		["hello@joebradford.net"]
	],
	"A8N-Donate": [
		["fundraising@km.redcross.org.lb", "contact@yemenaid.org", "email@alerts.savethechildren.org", "shiekh.islam@feelingblessed.org", "adviser@acceducate.org", "info@mausa.org", "communications@umrelief.org", "info@zakat.org"],
		["cevashavik@umrelief.org", "tauseef@feelingblessed.org"]
	],
	"A8N-Coffee": [
		["hello@email.breville.com", "hello_at_miir_com_x8gj12bc6z4jfb_33bn3409@icloud.com", "peetscoffee@info.peets.com", "hello@nichecoffee.co.uk"]
	],
	"A8N-Home": [
		["customerservice@daysofeid.com", "hello@carawayhome.com", "info@hello.rugs.com", "noreply@newsletter.zarinatableware.com", "riz@eidparty.co.uk", "energy@tesla.com"],
		["webinquiry@stansac.com", "designwithinreach@n.dwr.com", "noreply@goaptive.com"]
	],
	"A8N-Junk": [
		["updates@mail.pressrundown.com", "hello@milkandhoney.com", "sleepnumber@mailreply.sleepnumber.com", "foe@foe.org", "heartbase@widefrost.com", "office@complexmrs.com"],
		["info@vote.org", "message@m.truecarmail.com", "*.ccsend.com", "dtc-email@discounttire-email.com"]
	],
	"A8N-Health": [
		["registration@diversifydietetics.org", "lafitness@e.lafitness.com", "donotreply@ex.doctorondemand.com", "noreply@patient-message.com", "info@biresreor.com"],
		["tumbletechatx-notifications@ses.iclasspro.com", "info@mail.swishsmiles.com", "hello@email.myfitnesspal.com", "email@lifefitness.com"]
	],
	"A8N-Tech": [
		["updates@ui.com", "support@codepen.io", "sacerdoti@pipedream.com", "team@mail.notion.so"]
	]

	# Spammers
	# veganrichava@imail.com
}

yahoo_src_folder = "inbox"
for yahoo_dest_folder, email_set_chunks in folder_moving_rules.items():
	for email_set in email_set_chunks:
		url = email_set_to_url(email_set, yahoo_src_folder)
		print(f"Moving from[{yahoo_src_folder}] to[{yahoo_dest_folder}] for URL[{url}]")
		try: 
			move_emails_from_url_to_folder(driver, url, yahoo_dest_folder)
		except Exception as e:
			print(f"Failed to move from[{yahoo_src_folder}] to[{yahoo_dest_folder}] for URL[{url}]")
			print(traceback.format_exc())

driver.quit()