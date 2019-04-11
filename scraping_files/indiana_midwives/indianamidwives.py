from bs4 import BeautifulSoup
import csv
import re

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

licensees = '"Name","License #","License Type","Status","Issued","Expires","Other Documents" \n'

def tableParse(table, licensees):
    results_window = driver.window_handles[0]

    p = 3

    while p <= 16:
        page = 'datagrid_results__ctl' + str(p) + '_name'
        if page in driver.page_source:
            driver.find_element_by_id(page).click()
            #switch to pop up window
            details_window = driver.window_handles[1]
            driver.switch_to_window(details_window)
            print(page)
            print(details_window)
        details = BeautifulSoup(driver.page_source, 'html.parser')
        name = details.find('span', id='_ctl25__ctl1_full_name').text
        licenseNum = details.find('span', id='_ctl35__ctl1_license_no').text
        licenseType = details.find('span', id='_ctl35__ctl1_license_type').text
        status = details.find('span', id='_ctl35__ctl1_status').text
        issued = details.find('span', id='_ctl35__ctl1_issue_date').text
        expires = details.find('span', id='_ctl35__ctl1_expiry').text

        otherDocs = details.findAll('a', id=re.compile('^_ctl88__ctl?[0-9]_name'))
        otherDocs = ""
        for doc in otherDocs:
            otherDocs += doc['href'].text + ' '
        licensees += '"' + str(name) + '","' + str(licenseNum) + '","' + str(licenseType) + '","' + str(status) + '","' + str(issued) + '","' + str(expires) + '","' + str(otherDocs) + '"\n'

        #close pop up
        driver.close()
        #switch to original window
        driver.switch_to_window(results_window)
        p += 1
    return licensees



options = webdriver.ChromeOptions()
options.add_argument('headless')
options.add_argument('window-size=1200x600')
driver = webdriver.Chrome(chrome_options=options)



driver.get('https://mylicense.in.gov/everification/Search.aspx')


driver.find_element_by_xpath("//select[@name='t_web_lookup__license_type_name']/option[text()='Direct Entry Midwife']").click()
driver.find_element_by_css_selector('#sch_button').click()


licensees = tableParse(driver, licensees)

# nextPage = 1
# while nextPage <= 23:
#     scriptText = "javascript:__doPostBack('datagrid_results$_ctl44$_ctl" + str(nextPage) + "','')"
#     if scriptText in driver.page_source:
#         driver.execute_script(scriptText)
#         print("---- processing page " + str(nextPage) + " ----")
#         licensees = tableParse(driver, licensees)
#     nextPage += 1

with open("indianamidwives.csv", "w", encoding='utf-8') as f:
    f.write(licensees)

driver.quit()
