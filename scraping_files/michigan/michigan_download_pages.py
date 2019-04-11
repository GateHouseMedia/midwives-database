import pandas as pd
import os


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

url_root = 'https://aca3.accela.com/MILARA/GeneralProperty/LicenseeDetail.aspx?LicenseeNumber='


def download_page(record):
    os.system(
        'wget {}{} -O html/{}.html'.format(
            url_root,
            record,
            record
        )
    )
    return


active.Record.apply(download_page)
lapsed.Record.apply(download_page)
