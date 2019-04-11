from bs4 import BeautifulSoup
import csv
import re

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

licensees = '"Name","Address","License #","Profession","License Type","Status","Issued","Expires","Last Renewal Date","Discipline","Sanction","Other Documents" \n'

def tableParse(table, licensees):
    results_window = driver.window_handles[0]

    p = 3

    while p <= 42:
        page = 'datagrid_results__ctl' + str(p) + '_name'
        if page in driver.page_source:
            driver.find_element_by_id(page).click()
            #switch to pop up window
            details_window = driver.window_handles[1]
            driver.switch_to_window(details_window)

            details = BeautifulSoup(driver.page_source, 'html.parser')
            name = details.find('span', id='_ctl25__ctl1_full_name').text
            address = details.find('span', id='_ctl28__ctl1_addr_line_1').text + ',' + details.find('span', id='_ctl28__ctl1_addr_line_4').text
            licenseNum = details.find('span', id='_ctl34__ctl1_license_no').text
            profession = details.find('span', id='_ctl34__ctl1_profession').text
            licenseType = details.find('span', id='_ctl34__ctl1_license_type').text
            status = details.find('span', id='_ctl34__ctl1_status').text
            issued = details.find('span', id='_ctl34__ctl1_issue_date').text
            expires = details.find('span', id='_ctl34__ctl1_expiry').text
            renewal = details.find('span', id='_ctl34__ctl1_last_ren').text
            boardorders = details.find(text="Please see Documents section below for any Public Board Orders")
            if boardorders == None:
                print('none')
            docs = details.find(text="No Other Documents")
            if docs == None:
                print(licenseNum)
            otherDocs = details.findAll('a', id=re.compile('^_ctl88__ctl?[0-9]_name'))
            otherDocs = ""
            for doc in otherDocs:
                otherDocs += doc['href'].text + ' '
            licensees += '"' + str(name) + '","' + str(address) + '","' + str(licenseNum) + '","' + str(profession) + '","' + str(licenseType) + '","' + str(status) + '","' + str(issued) + '","' + str(expires) + '","' + str(renewal) + '","' + str(otherDocs) + '"\n'
        else:
            break
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



driver.get('http://verify.sos.ga.gov/verification/')


driver.find_element_by_xpath("//select[@name='t_web_lookup__license_type_name']/option[text()='Advanced Practice - CNM']").click()
driver.find_element_by_css_selector('#sch_button').click()


licensees = tableParse(driver, licensees)

nextPage = 1
while nextPage <= 23:
    scriptText = "javascript:__doPostBack('datagrid_results$_ctl44$_ctl" + str(nextPage) + "','')"
    if scriptText in driver.page_source:
        driver.execute_script(scriptText)
        print("---- processing page " + str(nextPage) + " ----")
        licensees = tableParse(driver, licensees)
    nextPage += 1

with open("newlicenses.csv", "w", encoding='utf-8') as f:
    f.write(licensees)

driver.quit()
