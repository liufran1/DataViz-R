from bs4 import BeautifulSoup
import csv
from urllib.request import urlopen

evidera_articles=[]


url = 'https://mkwrs.com/mk8/'
tableName = 'current_wr.csv'
def scrapeMK8(inputUrl,outputName):
    homepage = BeautifulSoup(urlopen(inputUrl))
    
    currentTable = homepage.find('table', attrs={ "class" : "wr"})
    
    headers = [header.text for header in currentTable.find_all('th')]
    
    rows = []
    
    for row in currentTable.find_all('tr'):
        #Japanese characters make things hard, force into string rep of binary literal
        rows.append([str(val.text.encode('utf8'))[2:-1] for val in row.find_all('td')])
    
    
    with open(outputName, 'w', newline='') as outputFile:
        writer = csv.writer(outputFile)
        writer.writerow(headers)
        writer.writerows(row for row in rows if row)
    
    outputFile.close()
    print("Entry Type: ")
    print(type(rows[1][1]))
scrapeMK8(url, tableName)