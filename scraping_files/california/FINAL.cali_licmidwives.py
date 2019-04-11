from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import Select
from bs4 import BeautifulSoup



hosturl = "https://search.dca.ca.gov/"
phantomJSlocation = r"phantomjs"
browser = webdriver.PhantomJS(executable_path=phantomJSlocation)
browser.implicitly_wait(10)
#for licensetype in ("8001", "4007", "4008"):

browser.get(hosturl)
browser.find_element_by_xpath("//select[@name='licenseType']").click()
browser.find_element_by_xpath("//option[@value='8001']").click()
browser.find_element_by_id("srchSubmitHome").click()
browser.implicitly_wait(30)
results = browser.page_source
soup = BeautifulSoup(results)
articles = soup.findAll("article",{"class":"post"})
print(len(articles))
output = "name, license_num, license_type, license_status, exp, second_status, city, state, county, zip, details\n"
for article in articles:
	uls = article.findAll("ul",{"class":"actions"})
	lis = uls[0].findAll("li")
	if len(lis) > 9:
		output += '"' + lis[0].find('h3').text.strip() + '"' + ","
		output += lis[1].find('span').text.strip() + ","
		if lis[2].find('strong') != None:
			lis[2].find('strong').extract()
		output += lis[2].text.strip() + ","
		if lis[3].find('strong') != None:
			lis[3].find('strong').extract()
		if lis[3].find('img') != None:
			lis[3].find('img').extract()
		output += lis[3].text.strip() + ","
		if lis[4].find('strong') != None:
			lis[4].find('strong').extract()
		output += '"' + lis[4].text.strip() + '"' + ","
		if lis[5].find('strong') != None:
			lis[5].find('strong').extract()
		output += lis[5].text.strip() + ","
		output += lis[6].find('span').text + ","
		output += lis[7].find('span').text + ","
		if lis[8].find('strong') != None:
			lis[8].find('strong').extract()
		output += lis[8].text.strip() + ","
		if lis[9].find('strong') != None:
			lis[9].find('strong').extract()
		output += lis[9].text.strip() + ","
		details = uls[1].findAll("li")
		link = details[1].find('a')
		output += "https://search.dca.ca.gov" + link.attrs['href']
		output += "\n"
with open("cali_licmidwives.csv", "w") as csv_file:
	csv_file.write(output)
	csv_file.close()
browser.close()
browser.quit()	
