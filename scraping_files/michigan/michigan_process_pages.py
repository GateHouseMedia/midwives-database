from bs4 import BeautifulSoup
import pandas as pd

# Store dictionaries of disciplinary records here
payload = []

# Store Records where disciplinary actions weren't found here
fails = []

# Store Records with disciplinary actions here
id_exists = []


def process_row(row, record, name):
    cells = row.find_all('span')
    return {
        'name': name,
        'action': cells[0].text,
        'status': cells[1].text,
        'start': cells[3].text,
        'end': cells[4].text,
        'record': record
    }

def process_file(record):
    soup = BeautifulSoup(
        open('html/{}.html'.format(record), 'r').read(),
        'lxml'
    )
    name = soup.find(id="ctl00_PlaceHolderMain_licenseeGeneralInfo_lblContactName_value").text
    # Look for table ID
    if len(soup.find_all(id='ctl00_PlaceHolderMain_ucConditon_gdvConditionList')) > 0:
        id_exists.append(record)

    try:
        bs = soup.find_all(id='ctl00_PlaceHolderMain_ucConditon_gdvConditionList')[0]
    except:
        # Return if table ID not present
        with open('disciplinary_actions_fails.csv', 'a') as daf:
            daf.write(record + ","  + name + "\n")
        return

    # If Table ID present, process the even and odd rows
    [payload.append(
        process_row(row, record, name)
    ) for row in bs.find_all(class_='ACA_TabRow_Even')]

    [payload.append(
        process_row(row, record, name)
    ) for row in bs.find_all(class_='ACA_TabRow_Odd')]


lapsed = pd.read_excel(
    'michigan_nursemidwives.xls',
    sheetname='Lapsed RN and Lapsed NM',
    dtype='str'
)

active = pd.read_excel(
    'michigan_nursemidwives.xls',
    sheetname='Active RN & Active_Lapsed NM ',
    dtype='str'
)


# Process the files for all the Records
active.Record.apply(process_file)
lapsed.Record.apply(process_file)

# Make a DataFrame out of the results and export CSV
pd.DataFrame(payload).rename(
    columns=lambda x: x.title()
).set_index('Record')[[
    'Name',
    'Action',
    'Status',
    'Start',
    'End'
]].to_csv('disciplinary_actions.csv')
